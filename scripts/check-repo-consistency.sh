#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/os/common/platform.sh"
source "$ROOT_DIR/scripts/os/common/layout.sh"

say() { echo "[CONSISTENCY] $*"; }
warn() { echo "[CONSISTENCY][WARN] $*"; }
err() { echo "[CONSISTENCY][ERROR] $*" >&2; }

require_file() {
  local path="$1"
  if [[ "$path" != /* ]]; then
    path="$ROOT_DIR/$path"
  fi
  if [[ ! -f "$path" ]]; then
    err "Missing required file: $path"
    exit 1
  fi
}

require_dir() {
  local path="$1"
  if [[ "$path" != /* ]]; then
    path="$ROOT_DIR/$path"
  fi
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

for tool in bash awk diff find sort python3 rg; do
  require_tool "$tool"
done

cd "$ROOT_DIR"

MACOS_PROFILE_ROOT="$(profile_runtime_root "macos")"
COMMON_AGENT_DIR="$(common_agent_skills_root)"
CUSTOM_SKILLS_DIR="$MACOS_PROFILE_ROOT/skills/custom"
CUSTOM_MANIFEST="$MACOS_PROFILE_ROOT/skills/manifests/custom-skills.manifest.txt"
CURATED_MANIFEST="$MACOS_PROFILE_ROOT/skills/manifests/curated-manifest.txt"
PORTABLE_RULES="$MACOS_PROFILE_ROOT/rules/default.rules"
RULES_TEMPLATE="$MACOS_PROFILE_ROOT/rules/default.rules.template"
RULES_SOURCE_SNAPSHOT="$MACOS_PROFILE_ROOT/rules/default.rules.source.snapshot"
CONFIG_TEMPLATE="$MACOS_PROFILE_ROOT/config/config.template.toml"
TOOLCHAIN_LOCK="$MACOS_PROFILE_ROOT/meta/toolchain.lock"

required_files=(
  "README.md"
  "LICENSE"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "SUPPORT.md"
  "CODE_OF_CONDUCT.md"
  "GOVERNANCE.md"
  "CHANGELOG.md"
  "CITATION.cff"
  "llms.txt"
  "llms-full.txt"
  ".github/CODEOWNERS"
  ".github/dependabot.yml"
  ".github/PULL_REQUEST_TEMPLATE.md"
  ".github/ISSUE_TEMPLATE/bug_report.yml"
  ".github/ISSUE_TEMPLATE/feature_request.yml"
  ".github/ISSUE_TEMPLATE/config.yml"
  ".github/workflows/ci.yml"
  ".github/workflows/release.yml"
  "docs/README.md"
  "docs/INDEX.md"
  "docs/ARCHITECTURE.md"
  "docs/setup/README.md"
  "docs/setup/PORTABLE_SETUP.md"
  "docs/setup/PROD_RUNBOOK.md"
  "docs/setup/os/macos.md"
  "docs/agents/README.md"
  "codex/README.md"
  "codex/os/README.md"
  "codex/os/common/README.md"
  "codex/os/common/agents/README.md"
  "codex/os/macos/README.md"
  "scripts/README.md"
  "$CONFIG_TEMPLATE"
  "$MACOS_PROFILE_ROOT/config/projects.local.example.toml"
  "$MACOS_PROFILE_ROOT/config/projects.trust.snapshot.toml"
  "$MACOS_PROFILE_ROOT/agents/global.AGENTS.md"
  "$TOOLCHAIN_LOCK"
  "$PORTABLE_RULES"
  "$RULES_TEMPLATE"
  "$RULES_SOURCE_SNAPSHOT"
  "$CUSTOM_MANIFEST"
  "$CURATED_MANIFEST"
)

required_dirs=(
  ".github"
  ".github/ISSUE_TEMPLATE"
  "docs"
  "docs/setup"
  "docs/agents"
  "codex"
  "codex/os"
  "codex/os/common"
  "codex/os/common/agents"
  "$COMMON_AGENT_DIR"
  "codex/os/macos"
  "$MACOS_PROFILE_ROOT"
  "$CUSTOM_SKILLS_DIR"
  "$MACOS_PROFILE_ROOT/skills/manifests"
  "scripts"
  "scripts/os"
  "scripts/os/common"
)

for file in "${required_files[@]}"; do
  require_file "$file"
done
for dir in "${required_dirs[@]}"; do
  require_dir "$dir"
done
say "Required files and directories: OK"

while IFS= read -r script; do
  bash -n "$script"
done < <(find scripts -type f -name '*.sh' | sort)
say "Shell syntax: OK"

python3 - <<'PY'
import tomllib
from pathlib import Path

path = Path("codex/os/macos/runtime/config/config.template.toml")
data = tomllib.loads(path.read_text(encoding="utf-8"))
assert data.get("approval_policy") == "never"
assert data.get("sandbox_mode") == "danger-full-access"
text = path.read_text(encoding="utf-8")
assert "__CONTEXT7_API_KEY__" in text
assert "__GITHUB_MCP_TOKEN__" in text
for needle in ("ctx7sk-", "gho_", "ghp_", "github_pat_"):
    assert needle not in text
print("config template OK")
PY
say "Config template: OK"

tmp_rules="$(mktemp)"
trap 'rm -f "${tmp_rules:-}"' EXIT
scripts/render-portable-rules.sh "$tmp_rules"
if ! diff -u "$tmp_rules" "$PORTABLE_RULES" >/dev/null; then
  err "Portable rules drift detected: $PORTABLE_RULES is not rendered from $CURATED_MANIFEST"
  exit 1
fi
if ! diff -u "$tmp_rules" "$RULES_TEMPLATE" >/dev/null; then
  err "Portable rules template drift detected: $RULES_TEMPLATE is not aligned with rendered output"
  exit 1
fi
say "Portable rules rendering: OK"

mapfile -t manifest_skills < <(read_nonempty_lines "$CUSTOM_MANIFEST" | sort)
mapfile -t custom_dirs < <(find "$CUSTOM_SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
mapfile -t shared_profiles < <(find "$COMMON_AGENT_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
mapfile -t doc_profiles < <(find docs/agents -mindepth 1 -maxdepth 1 -type f -name '*.md' -printf '%f\n' | sed 's/\.md$//' | grep -v '^README$' | sort)

if [[ ${#manifest_skills[@]} -eq 0 ]]; then
  err "Custom skill manifest is empty: $CUSTOM_MANIFEST"
  exit 1
fi
if [[ ${#custom_dirs[@]} -eq 0 ]]; then
  err "No custom skill directories found in $CUSTOM_SKILLS_DIR"
  exit 1
fi
if [[ "$(printf '%s\n' "${manifest_skills[@]}")" != "$(printf '%s\n' "${custom_dirs[@]}")" ]]; then
  err "Custom skill manifest and custom skill directories are out of sync"
  echo "[CONSISTENCY] Manifest skills:"
  printf '%s\n' "${manifest_skills[@]}"
  echo "[CONSISTENCY] Directory skills:"
  printf '%s\n' "${custom_dirs[@]}"
  exit 1
fi

for skill in "${custom_dirs[@]}"; do
  require_file "$CUSTOM_SKILLS_DIR/$skill/SKILL.md"
done
say "Custom skills and manifest: OK"

overlap="$(comm -12 <(printf '%s\n' "${shared_profiles[@]}") <(printf '%s\n' "${custom_dirs[@]}"))"
if [[ -n "$overlap" ]]; then
  err "Shared agent profiles overlap with custom skills:"
  printf '%s\n' "$overlap"
  exit 1
fi
say "Shared/custom skill split: OK"

if [[ "$(printf '%s\n' "${shared_profiles[@]}")" != "$(printf '%s\n' "${doc_profiles[@]}")" ]]; then
  err "docs/agents and shared agent profile directories are out of sync"
  echo "[CONSISTENCY] Shared profiles:"
  printf '%s\n' "${shared_profiles[@]}"
  echo "[CONSISTENCY] Docs:"
  printf '%s\n' "${doc_profiles[@]}"
  exit 1
fi
say "Agent docs and shared profiles: OK"

for banned in code-reviewer figma-implement-design security-ownership-map; do
  if rg -n --hidden \
    --glob '!CHANGELOG.md' \
    --glob '!scripts/check-repo-consistency.sh' \
    --glob '!.git/*' \
    "$banned" . >/dev/null; then
    err "Found stale removed-skill reference: $banned"
    exit 1
  fi
done
say "No stale removed-skill references: OK"

legacy_layout_hits="$(rg -n --hidden \
  --glob '!CHANGELOG.md' \
  --glob '!scripts/check-repo-consistency.sh' \
  --glob '!.git/*' \
  'codex/config/|codex/agents/|codex/meta/|codex/rules/|codex/skills/custom-skills|skills/codex-agents|skills/README\.md|templates/README\.md|codex-workstation-bootstrap' \
  README.md docs codex scripts .github llms.txt llms-full.txt CITATION.cff CONTRIBUTING.md SECURITY.md SUPPORT.md CODE_OF_CONDUCT.md GOVERNANCE.md 2>/dev/null || true)"
if [[ -n "$legacy_layout_hits" ]]; then
  err "Found stale legacy layout references"
  printf '%s\n' "$legacy_layout_hits"
  exit 1
fi
say "No stale legacy layout references: OK"

say "Repository consistency check passed"
