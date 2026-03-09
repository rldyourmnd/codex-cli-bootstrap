# OS Installer Layout

This directory contains the OS-specific installer layer used before the portable Codex payload is applied.

## Structure

- `common/`: shared shell helpers for OS detection and payload resolution
- `linux/README.md`: Linux installer entrypoints
- `macos/README.md`: macOS installer entrypoints
- `windows/README.md`: Windows installer entrypoints

The installer layer is separate from the mirrored runtime payload under `codex/os/*/runtime/`.
Installers prepare the machine-specific CLI prerequisites. The runtime payload restores the portable `~/.codex` state.
