# Shared OS Helpers

This directory contains shell helpers shared by the installer and restore scripts.

## Files

- `platform.sh`: platform detection and small cross-platform shell utilities
- `layout.sh`: runtime profile resolution, payload fallback, and shared path helpers

These helpers define the repository-wide contract for resolving Linux, macOS, and Windows payload paths.
