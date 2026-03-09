# Windows Setup

Use this guide when restoring the portable Codex baseline onto Windows.
Read [`../PROFILE_MATRIX.md`](../PROFILE_MATRIX.md) and [`../PORTABLE_SETUP.md`](../PORTABLE_SETUP.md) first if you need the broader flow.

## Current Role

Windows has its own PowerShell installer path and native profile slot under `codex/os/windows/runtime/*`.
If a native Windows export is not checked in yet, bootstrap and verify fall back to the current primary exported payload under `codex/os/linux/runtime/*`.

## 1. Install Codex

Run in PowerShell:

```powershell
./scripts/os/windows/install/ensure-codex.ps1
```

## 2. Optional: Install Claude Code

Run in PowerShell:

```powershell
./scripts/os/windows/install/ensure-claude-code.ps1
```

## 3. Restore Codex Mirror

Run the restore flow from a shell that can execute the repository bash scripts after Codex is installed, such as Git Bash or WSL.

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
