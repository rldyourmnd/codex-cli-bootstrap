#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/os/common/platform.sh"

say() { echo "[CONSISTENCY] $*"; }
warn() { echo "[CONSISTENCY][WARN] $*"; }
err() { echo "[CONSISTENCY][ERROR] $*" >&2; }

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    err "Missing required file: $path"
    exit 1
  fi
}

require_dir() {
  local path="$1"
  if [[ ! -d "$path" ]]; then
    err "Missing required directory: $path"
    exit 1
  fi
}

require_tool() {
  local tool="$1"
  if ! command -v "$tool" >/dev/null 2>&1; then
    err "Missing required tool: $tool"
    exit 1
  fi
}

for tool in bash sed tar base64 awk diff find sort; do
  require_tool "$tool"
done

cd "$ROOT_DIR"

required_files=(
  "README.md"
  "LICENSE"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "SUPPORT.md"
  "CODE_OF_CONDUCT.md"
  "GOVERNANCE.md"
  "CHANGELOG.md"
  "CODEOWNERS"
  ".github/dependabot.yml"
  ".github/PULL_REQUEST_TEMPLATE.md"
  ".github/ISSUE_TEMPLATE/bug_report.yml"
  ".github/ISSUE_TEMPLATE/feature_request.yml"
  ".github/ISSUE_TEMPLATE/config.yml"
  ".github/workflows/ci.yml"
  ".github/workflows/release.yml"
  "docs/README.md"
  "docs/ARCHITECTURE.md"
  "docs/setup/README.md"
  "docs/setup/PORTABLE_SETUP.md"
  "docs/setup/PROD_RUNBOOK.md"
  "docs/agents/README.md"
  "codex/README.md"
  "scripts/README.md"
  "skills/README.md"
  "templates/README.md"
  "templates/AGENTS.md"
  "codex/config/config.template.toml"
  "codex/agents/global.AGENTS.md"
  "codex/meta/toolchain.lock"
  "codex/skills/custom-skills.manifest.txt"
  "codex/skills/custom-skills.tar.gz.b64"
  "codex/skills/custom-skills.sha256"
  "codex/skills/curated-manifest.txt"
  "codex/rules/default.rules"
  "codex/rules/default.rules.template"
  "codex/rules/default.rules.source.snapshot"
)

for file in "${required_files[@]}"; do
  require_file "$ROOT_DIR/$file"
done

required_dirs=(
  ".github"
  ".github/ISSUE_TEMPLATE"
  "docs"
  "docs/setup"
  "docs/agents"
  "codex"
  "scripts"
  "skills"
  "skills/codex-agents"
  "templates"
)

for dir in "${required_dirs[@]}"; do
  require_dir "$ROOT_DIR/$dir"
done

say "Required files and directories: OK"

for f in \
  scripts/install.sh \
  scripts/verify.sh \
  scripts/codex-activate.sh \
  scripts/export-from-local.sh \
  scripts/bootstrap.sh \
  scripts/audit-codex-agents.sh \
  scripts/check-toolchain.sh \
  scripts/sync-codex-version.sh \
  scripts/render-portable-rules.sh \
  scripts/self-test.sh \
  scripts/check-repo-consistency.sh \
  scripts/build-release-bundle.sh \
  scripts/install-codex-agents.sh \
  scripts/os/common/platform.sh \
  scripts/os/macos/install/ensure-codex.sh \
  scripts/os/linux/install/ensure-codex.sh \
  scripts/os/macos/install/ensure-claude-code.sh \
  scripts/os/linux/install/ensure-claude-code.sh; do
  bash -n "$f"
done

say "Shell syntax: OK"

tmp_rules="$(mktemp)"
trap 'rm -f "${tmp_rules:-}" "${tmp_archive:-}"' EXIT
scripts/render-portable-rules.sh "$tmp_rules"
if ! diff -u "$tmp_rules" codex/rules/default.rules >/dev/null; then
  err "Portable rules drift detected: codex/rules/default.rules is not rendered from codex/skills/curated-manifest.txt"
  exit 1
fi
if ! diff -u "$tmp_rules" codex/rules/default.rules.template >/dev/null; then
  err "Portable rules template drift detected: codex/rules/default.rules.template is not aligned with rendered output"
  exit 1
fi

say "Portable rules rendering: OK"

tmp_archive="$(mktemp_with_suffix .tar.gz)"
base64_decode_file codex/skills/custom-skills.tar.gz.b64 "$tmp_archive"
archive_sha="$(sha256_file "$tmp_archive")"
expected_sha="$(cat codex/skills/custom-skills.sha256)"
if [[ "$archive_sha" != "$expected_sha" ]]; then
  err "Custom skills archive checksum mismatch"
  exit 1
fi

archive_skills="$(tar -tzf "$tmp_archive" | awk -F/ 'NF>1 && $1 != "." {print $1} NF>2 && $1=="." {print $2}' | sed '/^$/d' | sort -u)"
manifest_skills="$(read_nonempty_lines codex/skills/custom-skills.manifest.txt | sort)"

if [[ "$archive_skills" != "$manifest_skills" ]]; then
  err "Custom skills archive contents do not match codex/skills/custom-skills.manifest.txt"
  echo "[CONSISTENCY] Manifest skills:"
  printf '%s\n' "$manifest_skills"
  echo "[CONSISTENCY] Archive skills:"
  printf '%s\n' "$archive_skills"
  exit 1
fi

say "Custom skills archive and manifest: OK"

skill_profiles="$(find skills/codex-agents -mindepth 1 -maxdepth 1 -type d | sed 's|.*/||' | sort)"
doc_profiles="$(find docs/agents -mindepth 1 -maxdepth 1 -type f -name '*.md' | sed 's|.*/||' | sed 's/\.md$//' | grep -v '^README$' | sort)"

if [[ "$skill_profiles" != "$doc_profiles" ]]; then
  err "docs/agents and skills/codex-agents are out of sync"
  echo "[CONSISTENCY] Skill profiles:"
  printf '%s\n' "$skill_profiles"
  echo "[CONSISTENCY] Doc profiles:"
  printf '%s\n' "$doc_profiles"
  exit 1
fi

say "Agent docs and skill directories: OK"

for banned in code-reviewer figma-implement-design security-ownership-map; do
  if grep -RIn --exclude-dir=.git --exclude=CHANGELOG.md --exclude=check-repo-consistency.sh -- "$banned" . >/dev/null 2>&1; then
    err "Found stale banned reference: $banned"
    exit 1
  fi
done

say "No stale removed-skill references: OK"

if [[ -e codex/os/macos/snapshots/full-home/archive.tar.gz.b64 ]] || [[ -e codex/os/macos/snapshots/full-home/archive.sha256 ]] || [[ -e codex/os/macos/snapshots/full-home/manifest.txt ]]; then
  err "macOS full-home snapshot artifacts should be either fully maintained or absent; stale files found"
  exit 1
fi

say "OS snapshot layout sanity: OK"
say "Repository consistency check passed"
