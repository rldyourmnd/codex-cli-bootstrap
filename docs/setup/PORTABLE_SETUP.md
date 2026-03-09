# Portable Codex Setup

This is the canonical source-of-truth document for exporting, restoring, and validating the Codex environment represented by this repository.
The current implementation uses a direct-files os-first layout, not packed runtime archives.

## Scope

The canonical portable payload currently includes:

- `codex/os/macos/runtime/config/config.template.toml`
- `codex/os/macos/runtime/config/projects.local.example.toml`
- `codex/os/macos/runtime/config/projects.trust.snapshot.toml`
- `codex/os/macos/runtime/agents/global.AGENTS.md`
- `codex/os/macos/runtime/rules/default.rules`
- `codex/os/macos/runtime/rules/default.rules.source.snapshot`
- `codex/os/macos/runtime/rules/default.rules.template`
- `codex/os/macos/runtime/meta/toolchain.lock`
- `codex/os/macos/runtime/skills/custom/*` (23 custom skills)
- `codex/os/macos/runtime/skills/manifests/custom-skills.manifest.txt`
- `codex/os/macos/runtime/skills/manifests/curated-manifest.txt`
- `codex/os/common/agents/codex-agents/*` (9 shared agent profiles)

Linux and Windows currently keep explicit runtime placeholders so the path model remains stable while macOS stays the canonical populated profile.

## Restore On A Target Machine

Install Codex first:

```bash
scripts/os/macos/install/ensure-codex.sh
```

Optional Claude Code bootstrap:

```bash
scripts/os/macos/install/ensure-claude-code.sh
```

Set required environment variables:

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
```

Run the canonical restore flow:

```bash
scripts/bootstrap.sh --skip-curated
```

## Deterministic Install Only

Use this when Codex is already installed and you want only the repository payload applied:

```bash
scripts/install.sh --force --skip-curated --clean-skills --rules-mode exact
```

## Optional Curated Refresh

Use this when you explicitly want the curated OpenAI skill refresh step during install:

```bash
scripts/install.sh --force --clean-skills --rules-mode exact
```

## Portable-Safe Variant

Use this when you want the baseline without strict parity pinning:

```bash
scripts/bootstrap.sh --skip-curated --portable-rules --skip-project-trust --no-sync-codex-version --no-strict-toolchain
```

## Validate

```bash
scripts/check-toolchain.sh --strict-codex-only
scripts/verify.sh
scripts/audit-codex-agents.sh
scripts/codex-activate.sh --check-only
```

## Refresh Repository From A Local Machine

```bash
scripts/export-from-local.sh
scripts/self-test.sh
```

## Guardrails

- Export fails if the source global `AGENTS.md` is empty.
- Export fails if no non-system skills are found.
- Shared agent profiles and custom skills must not overlap by name.
- Secret-like values must remain placeholders in `config.template.toml`.

## Troubleshooting

- If `verify.sh` reports missing MCP auth, check your environment variables and `~/.codex/config.toml`.
- If `codex mcp list` is unavailable, install or upgrade Codex CLI first.
- If the curated install step fails, rerun with `--skip-curated`.
- If toolchain mismatch is reported, run `scripts/sync-codex-version.sh --apply`.

## Related Documents

- [`../../README.md`](../../README.md)
- [`README.md`](README.md)
- [`PROD_RUNBOOK.md`](PROD_RUNBOOK.md)
- [`os/macos.md`](os/macos.md)
