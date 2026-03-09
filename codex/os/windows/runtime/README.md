# Windows Runtime Profile Slot

This directory is reserved for a future native Windows export.

## Expected Modules

- `agents/`
- `config/`
- `meta/`
- `rules/`
- `skills/custom/`
- `skills/manifests/`

## Current Behavior

- Windows machines use the native PowerShell installer scripts under `scripts/os/windows/install/`
- if no native Windows payload is checked in here yet, restore and verification scripts fall back to the current primary exported payload under `codex/os/linux/runtime/`
- once a native Windows export is added, it must keep the same module boundaries as the Linux runtime payload
