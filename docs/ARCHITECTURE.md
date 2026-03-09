# Repository Architecture

This document explains how `codex-cli-bootstrap` is organized and how its artifacts flow between a source machine, the repository, and a restored target machine.

## Mental Model

The repository has three layers:

1. Repository-owned baseline
   - source-controlled shared agent profiles in `codex/os/common/agents/codex-agents/`
   - source-controlled docs in `docs/`
   - reusable starter templates in `templates/`
   - source-controlled automation in `scripts/`
2. Exported portable runtime state
   - sanitized config, rules, manifests, and direct custom skill payloads in `codex/os/macos/runtime/`
3. OS layout namespace
   - shared payload under `codex/os/common/`
   - populated runtime profile under `codex/os/macos/runtime/`
   - placeholder runtime roots under `codex/os/linux/runtime/` and `codex/os/windows/runtime/`

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

- `codex/os/macos/runtime/config/config.template.toml`
- `codex/os/macos/runtime/config/projects.trust.snapshot.toml`
- `codex/os/macos/runtime/agents/global.AGENTS.md`
- `codex/os/macos/runtime/rules/default.rules.source.snapshot`
- `codex/os/macos/runtime/rules/default.rules`
- `codex/os/macos/runtime/rules/default.rules.template`
- `codex/os/macos/runtime/skills/custom/*`
- `codex/os/macos/runtime/skills/manifests/custom-skills.manifest.txt`
- `codex/os/macos/runtime/meta/toolchain.lock`

### 3. Portable render step

`scripts/render-portable-rules.sh` generates:

- `codex/os/macos/runtime/rules/default.rules`
- `codex/os/macos/runtime/rules/default.rules.template`

from:

- `codex/os/macos/runtime/skills/manifests/curated-manifest.txt`

This keeps the portable rule baseline deterministic and readable.

### 4. Restore on the target machine

`scripts/install.sh` and `scripts/bootstrap.sh` restore the environment by applying:

- the portable config and AGENTS baseline,
- the selected rules mode,
- the exported direct custom skill payload,
- the repository-owned shared agent profiles from `codex/os/common/agents/codex-agents/`.

The shared agent profiles remain a distinct layer so the repository stays authoritative for those profiles without overlapping custom skill names.

### 5. Verification

The target machine is validated with:

- `scripts/check-toolchain.sh`
- `scripts/verify.sh`
- `scripts/audit-codex-agents.sh`
- `scripts/codex-activate.sh --check-only`

## Directory Responsibilities

- `docs/`: human-facing wiki and operator docs
- `codex/`: top-level exported artifact namespace
- `codex/os/common/`: shared payload used across profiles
- `codex/os/macos/runtime/`: canonical populated runtime payload
- `templates/`: reusable starter docs and policy templates derived from the baseline
- `scripts/`: operational lifecycle entrypoints

Each major module also carries a local `README.md` where the module boundary matters, so contributors can navigate by directory instead of inferring structure from scripts alone.

## Truth Boundaries

- If a change affects install/export behavior, `scripts/` and `docs/` must be updated together.
- If a change affects the baseline skill set, `codex/os/common/agents/`, `codex/os/macos/runtime/skills/`, and verification scripts must stay aligned.
- If a change affects runtime versions, `codex/os/macos/runtime/meta/toolchain.lock` and toolchain validation must remain consistent.

## What This Repository Intentionally Does Not Mirror By Default

Portable export mode does not commit:

- auth secrets,
- live session state,
- command history,
- transient runtime logs.

Those belong to the machine runtime, not to the public repository baseline.
