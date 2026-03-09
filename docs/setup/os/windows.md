# Windows Setup

This repository includes Windows installer skeletons but treats macOS and Ubuntu/Linux as the primary production path.
Read [`../README.md`](../README.md) and [`../PORTABLE_SETUP.md`](../PORTABLE_SETUP.md) first if you need the broader restore model.

## PowerShell installers

- `scripts/os/windows/install/ensure-codex.ps1`
- `scripts/os/windows/install/ensure-claude-code.ps1`

## Run manually in PowerShell

```powershell
./scripts/os/windows/install/ensure-codex.ps1
./scripts/os/windows/install/ensure-claude-code.ps1
```

## Notes

- Validate parity on Windows before promoting from skeleton to production.
- Treat Windows support as explicitly staged, not fully parity-guaranteed today.
