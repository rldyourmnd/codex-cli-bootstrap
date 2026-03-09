# macOS Setup

Profile payload lives under `codex/os/macos/runtime/*`.
Read [`../PORTABLE_SETUP.md`](../PORTABLE_SETUP.md) first if you need the broader restore model.

## 1. Install Codex

```bash
scripts/os/macos/install/ensure-codex.sh
```

## 2. Optional: Install Claude Code

```bash
scripts/os/macos/install/ensure-claude-code.sh
```

## 3. Restore Codex mirror

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
