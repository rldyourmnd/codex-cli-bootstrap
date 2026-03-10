# Portable Codex Setup

This is the canonical source-of-truth document for exporting, restoring, and validating the Codex environment represented by this repository.
The current implementation uses a direct-files OS-first layout, not packed runtime archives.

## Profile Model

The repository carries:

- shared cross-OS baseline in `codex/os/common/*`
- one primary exported runtime payload in `codex/os/linux/runtime/*`
- native runtime profile slots in `codex/os/macos/runtime/*` and `codex/os/windows/runtime/*`

Bootstrap and install resolve the current OS profile first.
If that profile does not yet have a native payload checked in, they fall back to the current primary exported payload.

## Scope

The current primary portable payload includes:

- `codex/os/linux/runtime/config/config.template.toml`
- `codex/os/linux/runtime/config/projects.local.example.toml`
- `codex/os/linux/runtime/config/projects.trust.snapshot.toml`
- `codex/os/linux/runtime/agents/global.AGENTS.md`
- `codex/os/linux/runtime/rules/default.rules`
- `codex/os/linux/runtime/rules/default.rules.source.snapshot`
- `codex/os/linux/runtime/rules/default.rules.template`
- `codex/os/linux/runtime/meta/toolchain.lock`
- `codex/os/linux/runtime/skills/custom/*` (23 custom skills)
- `codex/os/linux/runtime/skills/manifests/custom-skills.manifest.txt`
- `codex/os/linux/runtime/skills/manifests/curated-manifest.txt`
- `codex/os/common/agents/codex-agents/*` (9 shared agent profiles)

## Restore On A Target Machine

Install Codex first with the installer that matches your OS:

- Linux: `scripts/os/linux/install/ensure-codex.sh`
- macOS: `scripts/os/macos/install/ensure-codex.sh`
- Windows: `scripts/os/windows/install/ensure-codex.ps1`

Optional Claude Code bootstrap:

- Linux: `scripts/os/linux/install/ensure-claude-code.sh`
- macOS: `scripts/os/macos/install/ensure-claude-code.sh`
- Windows: `scripts/os/windows/install/ensure-claude-code.ps1`

Set required environment variables:

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
```

Run the canonical restore flow:

```bash
scripts/bootstrap.sh --skip-curated
```

This repository does not rely on `codex --full-auto` for its exact restore baseline. The current CLI maps that alias to `-a on-request --sandbox workspace-write`, while the mirrored runtime baseline is stored explicitly in `config.template.toml` as `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`.

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

`scripts/export-from-local.sh` exports into the runtime profile that matches the actual source OS.
Cross-profile export is rejected on purpose.

```bash
scripts/export-from-local.sh
scripts/self-test.sh
```

## Guardrails

- Export fails if the source global `AGENTS.md` is empty.
- Export fails if no non-system skills are found.
- Export fails if the requested target profile does not match the actual source OS.
- Shared agent profiles and custom skills must not overlap by name.
- Secret-like values must remain placeholders in `config.template.toml`.

## Troubleshooting

- If `verify.sh` reports missing MCP auth, check your environment variables and `~/.codex/config.toml`.
- If `codex mcp list` is unavailable, install or upgrade Codex CLI first.
- If the curated install step fails, rerun with `--skip-curated`.
- If toolchain mismatch is reported, run `scripts/sync-codex-version.sh --apply`.
- On Linux, the portable Serena MCP entry restores missing GUI session variables before launch so the web dashboard can auto-open under Codex. If the browser still does not open after install, restart Codex and use the dashboard URL shown in Serena logs as a fallback.

## Related Documents

- [`../../README.md`](../../README.md)
- [`README.md`](README.md)
- [`PROFILE_MATRIX.md`](PROFILE_MATRIX.md)
- [`PROD_RUNBOOK.md`](PROD_RUNBOOK.md)
- [`os/linux.md`](os/linux.md)
- [`os/macos.md`](os/macos.md)
- [`os/windows.md`](os/windows.md)
