#!/usr/bin/env bash

is_supported_profile_os() {
  case "$1" in
    macos|linux|windows) return 0 ;;
    *) return 1 ;;
  esac
}

list_supported_profile_oses() {
  printf '%s\n' linux macos windows
}

detect_profile_os() {
  local env_var
  for env_var in CODEX_CLI_BOOTSTRAP_PROFILE_OS CODEX_BOOTSTRAP_PROFILE_OS BETTER_CODEX_PROFILE_OS; do
    if [[ -n "${!env_var:-}" ]]; then
      printf '%s\n' "${!env_var}"
      return
    fi
  done
  platform_id
}

profile_runtime_root() {
  local profile="$1"
  printf '%s\n' "$ROOT_DIR/codex/os/$profile/runtime"
}

common_agent_skills_root() {
  printf '%s\n' "$ROOT_DIR/codex/os/common/agents/codex-agents"
}

profile_has_payload() {
  local profile="$1"
  local root
  root="$(profile_runtime_root "$profile")"
  [[ -f "$root/config/config.template.toml" ]]
}

list_populated_profile_oses() {
  local profile
  while IFS= read -r profile; do
    if profile_has_payload "$profile"; then
      printf '%s\n' "$profile"
    fi
  done < <(list_supported_profile_oses)
}

primary_payload_profile() {
  local profile
  while IFS= read -r profile; do
    printf '%s\n' "$profile"
    return 0
  done < <(list_populated_profile_oses)
  return 1
}

resolve_profile_os() {
  local requested="${1:-$(detect_profile_os)}"
  local primary
  if is_supported_profile_os "$requested" && profile_has_payload "$requested"; then
    printf '%s\n' "$requested"
    return
  fi
  primary="$(primary_payload_profile || true)"
  if [[ -n "$primary" ]]; then
    printf '%s\n' "$primary"
    return
  fi
  if is_supported_profile_os "$requested"; then
    printf '%s\n' "$requested"
    return
  fi
  printf 'linux\n'
}

resolve_runtime_root() {
  local requested="${1:-$(detect_profile_os)}"
  local resolved
  resolved="$(resolve_profile_os "$requested")"
  profile_runtime_root "$resolved"
}
