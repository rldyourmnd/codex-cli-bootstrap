#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/os/common/platform.sh"

# Codex MCP/Skills bootstrap and health check for this repo.
# Usage:
#   scripts/codex-activate.sh            # enable required MCP, then validate
#   scripts/codex-activate.sh --check-only

CHECK_ONLY=false
if [[ "${1:-}" == "--check-only" ]]; then
  CHECK_ONLY=true
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "[ERROR] codex CLI is not installed or not in PATH"
  exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo "[ERROR] python3 is not installed or not in PATH"
  exit 1
fi

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
CONFIG_FILE="$CODEX_HOME_DIR/config.toml"
SKILLS_DIR="$CODEX_HOME_DIR/skills"

REQUIRED_MCPS=(
  "context7"
  "github"
  "sequential-thinking"
  "shadcn"
  "serena"
  "chrome-devtools"
)

REQUIRED_SKILLS=(
  "frontend-design"
  "webapp-testing"
  "pptx"
  "hook-development"
  "command-development"
  "agent-development"
  "writing-rules"
  "codex-md-improver"
  "sql-queries"
  "search-strategy"
  "cloudflare-deploy"
  "gh-address-comments"
  "gh-fix-ci"
  "openai-docs"
  "pdf"
  "security-best-practices"
  "security-threat-model"
  "spreadsheet"
  "yeet"
  "playwright"
  "better-explorer"
  "serena-sync"
  "version-patrol"
  "better-think"
  "better-plan"
  "better-code-review"
  "manual-tester"
  "better-debugger"
  "github-server-sync"
  "init-project"
  "create-project"
  "status"
)

warn_count=0
err_count=0

say() { echo "[INFO] $*"; }
warn() { echo "[WARN] $*"; warn_count=$((warn_count + 1)); }
err() { echo "[ERROR] $*"; err_count=$((err_count + 1)); }

say "Collecting MCP status..."
MCP_LIST_JSON="$(codex mcp list --json || true)"
if [[ -z "$MCP_LIST_JSON" ]]; then
  err "Unable to read MCP status via 'codex mcp list --json'"
fi

if [[ -f "$CONFIG_FILE" ]]; then
  if grep -Eq -- '--enable-web-dashboard' "$CONFIG_FILE" && grep -Eq -- '--open-web-dashboard' "$CONFIG_FILE"; then
    say "Serena dashboard flags found in Codex config"
  else
    warn "Serena MCP config is missing dashboard startup flags"
  fi
  if grep -Eq 'DBUS_SESSION_BUS_ADDRESS|WAYLAND_DISPLAY|/tmp/\.X11-unix/X' "$CONFIG_FILE"; then
    say "Serena display environment recovery found in Codex config"
  else
    warn "Serena MCP config is missing display environment recovery for browser auto-open"
  fi
else
  warn "Codex config not found at $CONFIG_FILE"
fi

enable_mcp() {
  local name="$1"
  if $CHECK_ONLY; then
    return
  fi
  if codex mcp enable "$name" >/dev/null 2>&1; then
    say "MCP enabled: $name"
  else
    warn "Failed to enable MCP '$name' automatically (may require manual setup)"
  fi
}

for mcp in "${REQUIRED_MCPS[@]}"; do
  state="$(printf '%s' "$MCP_LIST_JSON" | python3 -c '
import json
import sys

name = sys.argv[1]
for entry in json.load(sys.stdin):
    if entry.get("name") == name:
        print("enabled" if entry.get("enabled") else "disabled")
        raise SystemExit(0)
raise SystemExit(1)
' "$mcp")" || {
    err "Missing MCP config: $mcp"
    continue
  }
  if [[ "$state" == "enabled" ]]; then
    say "MCP present/enabled: $mcp"
  else
    warn "MCP configured but disabled: $mcp"
    enable_mcp "$mcp"
  fi

done

MCP_LIST_AFTER_JSON="$(codex mcp list --json || true)"
config_context7_auth_present="$(python3 - "$CONFIG_FILE" <<'PY'
import sys
import tomllib
from pathlib import Path

path = Path(sys.argv[1])
if not path.exists():
    print("0")
    raise SystemExit(0)

data = tomllib.loads(path.read_text(encoding="utf-8"))
headers = data.get("mcp_servers", {}).get("context7", {}).get("http_headers", {})
value = headers.get("CONTEXT7_API_KEY") or headers.get("Authorization") or ""
print("1" if value and "__CONTEXT7_API_KEY__" not in value else "0")
PY
)"
context7_auth="$(printf '%s' "$MCP_LIST_AFTER_JSON" | python3 -c '
import json
import sys

for entry in json.load(sys.stdin):
    if entry.get("name") == "context7":
        print(entry.get("auth_status") or "")
        raise SystemExit(0)
raise SystemExit(1)
')"
if [[ "$context7_auth" == "not_logged_in" ]]; then
  if [[ "$config_context7_auth_present" == "1" ]]; then
    say "context7 reports not logged in, but token header is configured in config.toml (can be expected with token-based auth)."
  else
    warn "context7 MCP is enabled but not logged in (check CONTEXT7_API_KEY)"
  fi
fi
config_github_auth_present="$(python3 - "$CONFIG_FILE" <<'PY'
import sys
import tomllib
from pathlib import Path

path = Path(sys.argv[1])
if not path.exists():
    print("0")
    raise SystemExit(0)

data = tomllib.loads(path.read_text(encoding="utf-8"))
headers = data.get("mcp_servers", {}).get("github", {}).get("http_headers", {})
value = headers.get("Authorization") or ""
print("1" if value and "__GITHUB_MCP_TOKEN__" not in value else "0")
PY
)"
github_auth="$(printf '%s' "$MCP_LIST_AFTER_JSON" | python3 -c '
import json
import sys

for entry in json.load(sys.stdin):
    if entry.get("name") == "github":
        print(entry.get("auth_status") or "")
        raise SystemExit(0)
raise SystemExit(1)
')"
if [[ "$github_auth" == "not_logged_in" ]]; then
  if [[ "$config_github_auth_present" == "1" ]]; then
    say "github reports not logged in, but bearer header is configured in config.toml (can be expected with token-based auth)."
  else
    warn "github MCP is enabled but not logged in (check token/header in Codex config)"
  fi
fi

say "Validating required skills in $SKILLS_DIR"
if [[ ! -d "$SKILLS_DIR" ]]; then
  err "Skills directory not found: $SKILLS_DIR"
else
  for skill in "${REQUIRED_SKILLS[@]}"; do
    if [[ ! -d "$SKILLS_DIR/$skill" ]]; then
      err "Missing skill directory: $skill"
      continue
    fi
    if [[ ! -f "$SKILLS_DIR/$skill/SKILL.md" ]]; then
      err "Missing SKILL.md: $skill"
      continue
    fi
    if ! grep -Eq '^name:' "$SKILLS_DIR/$skill/SKILL.md"; then
      warn "SKILL.md has no 'name:' field: $skill"
    fi
    if ! grep -Eq '^description:' "$SKILLS_DIR/$skill/SKILL.md"; then
      warn "SKILL.md has no 'description:' field: $skill"
    fi
    say "Skill OK: $skill"
  done

  say "Auditing all installed skills for SKILL.md/frontmatter"
  installed_skill_dirs=()
  while IFS= read -r dir; do
    installed_skill_dirs+=("$dir")
  done < <(list_top_level_dirs "$SKILLS_DIR")
  for installed in "${installed_skill_dirs[@]}"; do
    if [[ "$installed" == ".system" ]]; then
      continue
    fi
    if [[ ! -f "$SKILLS_DIR/$installed/SKILL.md" ]]; then
      err "Installed skill has no SKILL.md: $installed"
      continue
    fi
    if ! grep -Eq '^name:' "$SKILLS_DIR/$installed/SKILL.md"; then
      warn "Installed SKILL.md has no 'name:' field: $installed"
    fi
    if ! grep -Eq '^description:' "$SKILLS_DIR/$installed/SKILL.md"; then
      warn "Installed SKILL.md has no 'description:' field: $installed"
    fi
  done

  # Duplicate skill name detection from frontmatter.
  skill_files=()
  while IFS= read -r file; do
    skill_files+=("$file")
  done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -type f -name 'SKILL.md' | sort)
  if [[ ${#skill_files[@]} -gt 0 ]]; then
    dupes="$(awk '/^name:/ {print $2}' "${skill_files[@]}" | sort | uniq -d || true)"
    if [[ -n "$dupes" ]]; then
      warn "Duplicate skill name(s) detected in frontmatter: $dupes"
    else
      say "No duplicate frontmatter names detected across installed skills"
    fi
  fi
fi

if [[ $err_count -gt 0 ]]; then
  echo
  err "Bootstrap finished with $err_count error(s), $warn_count warning(s)"
  exit 1
fi

echo
say "Bootstrap finished successfully with $warn_count warning(s)"
exit 0
