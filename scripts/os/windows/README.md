# Windows Installer Scripts

This directory contains Windows-specific bootstrap entrypoints.

## Files

- `install/ensure-codex.ps1`: installs or verifies the required Codex CLI version on Windows
- `install/ensure-claude-code.ps1`: optional Claude Code bootstrap for Windows

Windows restore currently uses this native installer layer plus the repository runtime payload resolved by `scripts/os/common/layout.sh`.
