# Portable Codex Setup And Restore Modes

This is the canonical source-of-truth document for exporting, restoring, and validating the Codex environment represented by this repository.
Other setup-facing pages should point back here instead of redefining the workflow.

Per-OS quick guides:
- `docs/setup/os/macos.md`
- `docs/setup/os/ubuntu.md`
- `docs/setup/os/windows-skeleton.md`

## Scope

The snapshot intentionally includes only reproducible settings:

- Global Codex config (`config.toml` template)
- Global AGENTS policy (`~/.codex/AGENTS.md`)
- Global rules (`~/.codex/rules/default.rules`) in two forms:
  - portable baseline (`codex/rules/default.rules`)
  - source snapshot (`codex/rules/default.rules.source.snapshot`)
- All non-system installed skills (`~/.codex/skills/*`, excluding `.system`)
- Repository baseline agent skills (`skills/codex-agents/*`) are always installed on target
- Toolchain lock (`codex/meta/toolchain.lock`)
- Optional project trust snapshot (`codex/config/projects.trust.snapshot.toml`)
- Optional full OS-specific `~/.codex` snapshot (`codex/os/<os>/snapshots/full-home/*`)

Default export intentionally excludes runtime/session files (auth/session/history/log).
Use `--with-full-home` if you need an absolute mirror, including runtime/session state.

## Restore Modes

### Portable baseline mode

This is the default and recommended mode for most users.
It restores the reproducible Codex baseline without committing live machine runtime state to the repository.

Use:

```bash
scripts/bootstrap.sh --skip-curated
```

### Full-home mirror mode

This mode restores an OS-specific full-home snapshot and is intended only when you explicitly need a same-family machine mirror.

Use:

```bash
scripts/bootstrap.sh --skip-curated --full-home
```

## Export from source machine

```bash
scripts/export-from-local.sh
scripts/self-test.sh
```

Optional custom source path:

```bash
scripts/export-from-local.sh /path/to/.codex
```

Absolute mirror export:

```bash
scripts/export-from-local.sh --with-full-home
```

Guardrails:

- Export fails if source `AGENTS.md` is empty.
- Export fails if no non-system skills are found.
- Override only when intentional: `--allow-empty-agents` / `--allow-empty-skills`.

## Restore on target machine

Install Codex first:

macOS:

```bash
brew install --cask codex
```

Linux:

```bash
npm i -g @openai/codex
```

Optional Claude Code bootstrap:

macOS:

```bash
scripts/os/macos/install/ensure-claude-code.sh
```

Ubuntu/Linux:

```bash
scripts/os/linux/install/ensure-claude-code.sh
```

Set required environment variables (for deterministic template mode):

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
```

Run one-command restore:

```bash
scripts/bootstrap.sh --skip-curated
```

Restore with Codex + Claude Code in one run:

```bash
scripts/bootstrap.sh --skip-curated --with-claude-code
```

Install applies both:
- snapshot skills from `codex/skills/custom-skills.*`,
- repository baseline 9 agent skills from `skills/codex-agents`.

Exact parity is default in bootstrap (rules mode `exact`, project trust apply enabled, Codex version sync enabled, toolchain parity check enabled).

Portable-safe variant:

```bash
scripts/bootstrap.sh --skip-curated --portable-rules --skip-project-trust --no-sync-codex-version --no-strict-toolchain
```

## Deterministic vs latest restore

- Deterministic restore: `scripts/bootstrap.sh --skip-curated`
- Snapshot + curated refresh: `scripts/bootstrap.sh`

## Validation

```bash
scripts/check-toolchain.sh --strict-codex-only
scripts/verify.sh
scripts/audit-codex-agents.sh
scripts/codex-activate.sh --check-only
```

For absolute mirror mode:

```bash
scripts/verify.sh --full-home
```

## Troubleshooting

- If `verify.sh` reports missing MCP auth, check env vars and `~/.codex/config.toml`.
- In full-home mode, `verify.sh --full-home` reports missing MCP entries as warnings (not hard failures).
- If `codex mcp list` is unavailable, install/upgrade Codex CLI first.
- If curated install fails, rerun with `--skip-curated`.
- If Codex version mismatch is reported, run `scripts/sync-codex-version.sh --apply`.
- Windows skeleton installers are provided in `scripts/os/windows/install/`.

## Related Documents

- [`../../README.md`](../../README.md): project overview
- [`README.md`](README.md): setup docs index
- [`PROD_RUNBOOK.md`](PROD_RUNBOOK.md): operations, rollback, and drift management
- [`os/macos.md`](os/macos.md): macOS quick guide
- [`os/ubuntu.md`](os/ubuntu.md): Ubuntu/Linux quick guide
- [`os/windows-skeleton.md`](os/windows-skeleton.md): Windows staged support notes
