# Repository Architecture

This document explains how `better-codex` is organized and how its artifacts flow between a source machine, the repository, and a restored target machine.

## Mental Model

The repository has three layers:

1. Repository-owned baseline
   - source-controlled skill definitions in `skills/codex-agents/`
   - source-controlled docs in `docs/`
   - source-controlled automation in `scripts/`
2. Exported portable runtime state
   - sanitized config, rules, manifests, and packed skill snapshots in `codex/`
3. Optional machine-specific absolute snapshot layer
   - per-OS full-home snapshots under `codex/os/<os>/snapshots/full-home/`

The repository-owned baseline explains how the system should work.
The exported runtime state captures what was actually installed on the source machine at export time.

## Main Data Flow

### 1. Source machine

The source machine has a real `~/.codex` tree with:

- `config.toml`
- `AGENTS.md`
- `rules/default.rules`
- installed custom skills under `~/.codex/skills/`

### 2. Export into the repository

`scripts/export-from-local.sh` reads the source machine state and updates:

- `codex/config/config.template.toml`
- `codex/agents/global.AGENTS.md`
- `codex/rules/default.rules.source.snapshot`
- `codex/skills/custom-skills.manifest.txt`
- `codex/skills/custom-skills.tar.gz.b64`
- `codex/meta/toolchain.lock`

If requested with `--with-full-home`, it also exports a full-home snapshot for the current OS family.

### 3. Portable render step

`scripts/render-portable-rules.sh` generates:

- `codex/rules/default.rules`
- `codex/rules/default.rules.template`

from:

- `codex/skills/curated-manifest.txt`

This keeps the portable rule baseline deterministic and readable.

### 4. Restore on the target machine

`scripts/install.sh` and `scripts/bootstrap.sh` restore the environment by applying:

- the portable config and AGENTS baseline,
- the selected rules mode,
- the exported custom skill snapshot,
- the repository-owned baseline skills from `skills/codex-agents/`.

The repository-owned baseline skills are re-applied after custom skill restore so that the repository stays authoritative for those agent profiles.

### 5. Verification

The target machine is validated with:

- `scripts/check-toolchain.sh`
- `scripts/verify.sh`
- `scripts/audit-codex-agents.sh`
- `scripts/codex-activate.sh --check-only`

## Directory Responsibilities

- `docs/`: human-facing wiki and operator docs
- `codex/`: exported artifacts and portable machine-readable state
- `scripts/`: operational lifecycle entrypoints
- `skills/`: repository-owned agent skill source
- `templates/`: reusable project templates based on this baseline

## Truth Boundaries

- If a change affects install/export behavior, `scripts/` and `docs/` must be updated together.
- If a change affects the baseline skill set, `skills/`, `codex/skills/`, and verification scripts must stay aligned.
- If a change affects runtime versions, `codex/meta/toolchain.lock` and toolchain validation must remain consistent.

## What This Repository Intentionally Does Not Mirror By Default

Portable export mode does not commit:

- auth secrets,
- live session state,
- command history,
- transient runtime logs.

Those belong to the machine runtime, not to the public repository baseline.
