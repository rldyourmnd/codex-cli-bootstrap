# Common Payload

This directory contains cross-OS repository-owned payload that is not tied to a single runtime export.

## Modules

- `agents/README.md`: shared agent profile catalog
- `agents/codex-agents/`: repository-owned Codex agent skill baseline

The shared agent layer is intentionally separate from exported custom skills so install logic can keep repository-owned agents authoritative across restores.
