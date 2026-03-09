# Setup Documentation

This directory contains the operational documentation for exporting, restoring, validating, and troubleshooting the Codex environment mirrored by this repository.

## Core Guides

- [`PROFILE_MATRIX.md`](PROFILE_MATRIX.md): OS support, payload source, and current parity state
- [`PORTABLE_SETUP.md`](PORTABLE_SETUP.md): canonical setup and restore guide
- [`PROD_RUNBOOK.md`](PROD_RUNBOOK.md): operator runbook for repeatable production-grade use

## Per-OS Guides

- [`os/linux.md`](os/linux.md): Linux-specific notes
- [`os/macos.md`](os/macos.md): macOS-specific notes
- [`os/windows.md`](os/windows.md): Windows-specific notes

## Recommended Reading Order

1. Read [`../../README.md`](../../README.md) for project scope.
2. Read [`../ARCHITECTURE.md`](../ARCHITECTURE.md) if you need the repository mental model.
3. Read [`PROFILE_MATRIX.md`](PROFILE_MATRIX.md) for the current OS support model.
4. Read [`PORTABLE_SETUP.md`](PORTABLE_SETUP.md) for the baseline workflow.
5. Read [`PROD_RUNBOOK.md`](PROD_RUNBOOK.md) if you operate the repo repeatedly or maintain other machines with it.
6. Read the OS-specific guide only when platform details matter.
