# macOS Installer Scripts

This directory contains macOS-specific bootstrap entrypoints.

## Files

- `install/ensure-codex.sh`: installs or verifies the required Codex CLI version on macOS
- `install/ensure-claude-code.sh`: optional Claude Code bootstrap for macOS

macOS restore currently uses this native installer layer plus the repository runtime payload resolved by `scripts/os/common/layout.sh`.
