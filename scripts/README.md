# Script Modules

This directory contains the automation entrypoints for exporting, restoring, validating, and auditing the Codex environment.

## Lifecycle Groups

- Export:
  - `export-from-local.sh`
  - `render-portable-rules.sh`
- Install and bootstrap:
  - `install.sh`
  - `bootstrap.sh`
  - `install-codex-agents.sh`
- Verification and audit:
  - `check-toolchain.sh`
  - `check-repo-consistency.sh`
  - `verify.sh`
  - `audit-codex-agents.sh`
  - `codex-activate.sh`
  - `self-test.sh`
- Release packaging:
  - `build-release-bundle.sh`
- Version management:
  - `sync-codex-version.sh`
- OS-specific installers:
  - `os/README.md`
  - `os/<os>/README.md`
  - `os/<os>/install/*`
- Shared shell helpers:
  - `os/common/platform.sh`
  - `os/common/layout.sh`

## Recommended Flow

1. Export from a known-good source machine with `export-from-local.sh`.
2. Refresh portable rules through `render-portable-rules.sh` when the curated manifest changes.
3. Restore with `install.sh` or `bootstrap.sh`.
4. Validate with `check-repo-consistency.sh`, `check-toolchain.sh`, `verify.sh`, `audit-codex-agents.sh`, and `codex-activate.sh --check-only`.
5. Build distributable release artifacts with `build-release-bundle.sh` when preparing tagged releases.

GitHub Actions reuses the same repository entrypoints for repository consistency, agent audit, and release-bundle validation so CI stays aligned with the documented operator flow.

## Scope Boundary

These scripts are the operational surface of the repository.
If you change any export, manifest, parity, or restore behavior, update the relevant documentation under `docs/` and re-run the verification chain before merging.

The current implementation is built around a profile-aware OS-first layout:

- shared agent profiles are resolved through `scripts/os/common/layout.sh`
- the current primary exported runtime profile is `codex/os/linux/runtime/*`
- macOS and Windows keep explicit native profile slots
- install and verify fall back to the primary exported payload when a native OS payload is not present yet
- export writes only to the runtime profile that matches the actual source OS

`audit-codex-agents.sh` also attempts an additional OpenAI skill-creator validation when the local `quick_validate.py` helper and its Python dependency set are available.
