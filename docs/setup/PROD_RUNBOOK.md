# Codex Environment Runbook

This runbook covers repeatable operations, rollback, and drift control around the canonical setup flow described in [`PORTABLE_SETUP.md`](PORTABLE_SETUP.md).

## Source Machine Update

```bash
scripts/export-from-local.sh
scripts/check-toolchain.sh --strict-codex-only
scripts/audit-codex-agents.sh
scripts/self-test.sh
```

## Target Machine Restore (Exact Mirror)

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
scripts/bootstrap.sh --skip-curated
```

## Target Machine Restore (Portable-Safe)

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
scripts/bootstrap.sh --skip-curated --portable-rules --skip-project-trust --no-sync-codex-version --no-strict-toolchain
```

## Validation Gates

```bash
scripts/check-toolchain.sh --strict-codex-only
scripts/verify.sh
scripts/audit-codex-agents.sh
scripts/codex-activate.sh --check-only
```

## Parity Model

- 6 MCP entries in the config template
- 23 direct custom skills under `codex/os/linux/runtime/skills/custom/*`
- 9 shared Codex agent profiles under `codex/os/common/agents/codex-agents/*`
- global `AGENTS.md` snapshot from the source machine
- strict no-overlap rule between custom and shared skill groups
- profile-aware fallback from staged native profile slots to the current primary exported payload

## Rollback

Install creates backups in `~/.codex` for overwritten files:

- `config.toml.bak.<timestamp>`
- `AGENTS.md.bak.<timestamp>`
- `rules/default.rules.bak.<timestamp>`

Restore an earlier file version by copying the desired backup over the active file.

## Drift Management

- `scripts/render-portable-rules.sh` keeps portable rules synchronized with `curated-manifest.txt`
- `scripts/check-toolchain.sh` detects version drift against `toolchain.lock`
- `scripts/sync-codex-version.sh --apply` re-pins the Codex CLI
- `scripts/check-repo-consistency.sh` validates repository structure before release
- `scripts/build-release-bundle.sh` builds the tagged portable bundle consumed by GitHub Releases
