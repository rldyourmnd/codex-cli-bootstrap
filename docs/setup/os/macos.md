# macOS Setup

Use this guide when restoring the portable Codex baseline onto macOS.
Read [`../PROFILE_MATRIX.md`](../PROFILE_MATRIX.md) and [`../PORTABLE_SETUP.md`](../PORTABLE_SETUP.md) first if you need the broader flow.

## Current Role

macOS has its own installer path and native profile slot under `codex/os/macos/runtime/*`.
If a native macOS export is not checked in yet, bootstrap and verify fall back to the current primary exported payload under `codex/os/linux/runtime/*`.

## 1. Install Codex

```bash
scripts/os/macos/install/ensure-codex.sh
```

## 2. Optional: Install Claude Code

```bash
scripts/os/macos/install/ensure-claude-code.sh
```

## 3. Restore Codex Mirror

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
scripts/bootstrap.sh --skip-curated
```

## 4. Validate

```bash
scripts/check-toolchain.sh --strict-codex-only
scripts/verify.sh
scripts/codex-activate.sh --check-only
scripts/audit-codex-agents.sh
```
