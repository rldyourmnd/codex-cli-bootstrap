# Codex Artifact Layout

This directory is the top-level namespace for the exported Codex runtime baseline.

## Layout

- `os/README.md`: OS payload overview
- `os/common/`: shared payload used across OS profiles
- `os/common/agents/codex-agents/`: shared Codex agent profile source of truth
- `os/macos/runtime/`: canonical populated runtime payload
- `os/macos/runtime/README.md`: module map for the populated runtime payload
- `os/linux/runtime/`: placeholder runtime root for future Linux payloads
- `os/linux/runtime/README.md`: placeholder contract for future Linux parity
- `os/windows/runtime/`: placeholder runtime root for future Windows payloads
- `os/windows/runtime/README.md`: placeholder contract for future Windows parity

## Source-Of-Truth Rules

- `os/macos/runtime/config/config.template.toml` is the portable configuration baseline
- `os/macos/runtime/config/projects.trust.snapshot.toml` stores sanitized project trust entries
- `os/macos/runtime/rules/default.rules.source.snapshot` reflects the source machine's exact exported rules
- `os/macos/runtime/rules/default.rules` and `default.rules.template` are rendered from `os/macos/runtime/skills/manifests/curated-manifest.txt`
- `os/macos/runtime/skills/manifests/custom-skills.manifest.txt` reflects the exact custom skill set at export time
- `os/macos/runtime/meta/toolchain.lock` defines the expected runtime versions for strict parity checks

## Notes

- The current export model is direct-files only. Packed custom skill archives are intentionally no longer part of the canonical layout.
- Shared agent profiles and custom skills are separated by directory and by install logic.
- Portable artifacts in this directory are consumed by the lifecycle scripts documented in [`../scripts/README.md`](../scripts/README.md).
- Each runtime root carries a local `README.md` so the hierarchy stays understandable even when a directory is only a placeholder today.
