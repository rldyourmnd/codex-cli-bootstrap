# macOS Runtime Profile Slot

This directory is reserved for a future native macOS export.

## Expected Modules

- `agents/`
- `config/`
- `meta/`
- `rules/`
- `skills/custom/`
- `skills/manifests/`

## Current Behavior

- macOS machines use the native macOS installer scripts under `scripts/os/macos/install/`
- if no native macOS payload is checked in here yet, restore and verification scripts fall back to the current primary exported payload under `codex/os/linux/runtime/`
- once a native macOS export is added, it must keep the same module boundaries as the Linux runtime payload
