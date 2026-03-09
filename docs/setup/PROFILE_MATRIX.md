# OS Profile Matrix

This repository keeps an OS-first hierarchy even when every operating system does not yet have its own native exported payload.

## Current matrix

| OS | Installer path | Runtime payload used today | Status |
| --- | --- | --- | --- |
| Linux / Ubuntu | `scripts/os/linux/install/*` | `codex/os/linux/runtime/*` | Primary exported payload |
| macOS | `scripts/os/macos/install/*` | falls back to `codex/os/linux/runtime/*` until a native macOS export is added | Supported restore path, native slot staged |
| Windows | `scripts/os/windows/install/*` | falls back to `codex/os/linux/runtime/*` until a native Windows export is added | Supported restore path, native slot staged |

## Why the fallback works

The repository mirrors the portable Codex home-directory state:

- `~/.codex/config.toml`
- `~/.codex/AGENTS.md`
- `~/.codex/rules/default.rules`
- `~/.codex/skills/*`

Those artifacts are largely OS-agnostic.
The OS-specific installers are responsible for provisioning the local CLI layer, while the mirrored payload provides the portable Codex state itself.

## Native export rules

- `scripts/export-from-local.sh` writes only to the runtime profile that matches the actual source OS
- cross-profile export is rejected
- any future native macOS or Windows export must keep the same module boundaries used by `codex/os/linux/runtime/`
