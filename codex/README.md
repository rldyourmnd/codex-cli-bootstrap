# Codex Artifact Layout

This directory is the top-level namespace for the exported Codex runtime baseline.

## Layout

- `os/README.md`: OS profile overview
- `os/common/`: shared repository-owned payload used across all OS profiles
- `os/common/agents/codex-agents/`: shared Codex agent profile source of truth
- `os/linux/runtime/`: current primary exported runtime payload
- `os/linux/runtime/README.md`: module map for the primary exported payload
- `os/macos/runtime/`: native macOS profile slot
- `os/macos/runtime/README.md`: contract for future native macOS payloads
- `os/windows/runtime/`: native Windows profile slot
- `os/windows/runtime/README.md`: contract for future native Windows payloads

## Source-Of-Truth Rules

- `os/linux/runtime/config/config.template.toml` is the current portable configuration baseline
- `os/linux/runtime/config/projects.trust.snapshot.toml` stores sanitized project trust entries
- `os/linux/runtime/rules/default.rules.source.snapshot` reflects the source machine's exact exported rules
- `os/linux/runtime/rules/default.rules` and `default.rules.template` are rendered from `os/linux/runtime/skills/manifests/curated-manifest.txt`
- `os/linux/runtime/skills/manifests/custom-skills.manifest.txt` reflects the exact custom skill set at export time
- `os/linux/runtime/meta/toolchain.lock` defines the expected runtime versions for strict parity checks

## Notes

- The current export model is direct-files only. Packed runtime archives are intentionally not the canonical layout.
- Shared agent profiles and exported custom skills are separated by directory and by install logic.
- Restore scripts resolve the current OS profile first and fall back to the primary exported payload when a native payload is not present yet.
- Each runtime root carries a local `README.md` so the hierarchy stays understandable even when a profile slot is only staged today.
