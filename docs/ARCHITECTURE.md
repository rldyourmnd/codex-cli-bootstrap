# Repository Architecture

This document explains how `codex-cli-bootstrap` is organized and how its artifacts flow between a source machine, the repository, and a restored target machine.

## Mental Model

The repository has three layers:

1. Repository-owned shared baseline
   - source-controlled shared agent profiles in `codex/os/common/agents/codex-agents/`
   - source-controlled docs in `docs/`
   - reusable starter templates in `templates/`
   - source-controlled automation in `scripts/`
2. Primary exported runtime state
   - sanitized config, rules, manifests, and direct custom skill payloads in `codex/os/linux/runtime/`
3. Native profile slots
   - stable OS-specific runtime roots under `codex/os/macos/runtime/` and `codex/os/windows/runtime/`

The shared baseline explains how the system should work across every machine.
The exported runtime state captures what was actually installed on the source machine at export time.
The native profile slots preserve a clean OS-first hierarchy so future exports can be added without restructuring the repository.

## Main Data Flow

### 1. Source machine

The source machine has a real `~/.codex` tree with:

- `config.toml`
- `AGENTS.md`
- `rules/default.rules`
- installed custom skills under `~/.codex/skills/`

### 2. Export into the repository

`scripts/export-from-local.sh` reads the source machine state and updates the runtime payload that matches the actual source OS.
Cross-profile export is intentionally rejected so the repository never claims a native payload that was not really exported on that OS.

The current primary export updates:

- `codex/os/linux/runtime/config/config.template.toml`
- `codex/os/linux/runtime/config/projects.trust.snapshot.toml`
- `codex/os/linux/runtime/agents/global.AGENTS.md`
- `codex/os/linux/runtime/rules/default.rules.source.snapshot`
- `codex/os/linux/runtime/rules/default.rules`
- `codex/os/linux/runtime/rules/default.rules.template`
- `codex/os/linux/runtime/skills/custom/*`
- `codex/os/linux/runtime/skills/manifests/custom-skills.manifest.txt`
- `codex/os/linux/runtime/meta/toolchain.lock`

### 3. Portable render step

`scripts/render-portable-rules.sh` generates:

- `codex/os/linux/runtime/rules/default.rules`
- `codex/os/linux/runtime/rules/default.rules.template`

from:

- `codex/os/linux/runtime/skills/manifests/curated-manifest.txt`

This keeps the portable rule baseline deterministic and readable.

### 4. Restore on the target machine

`scripts/install.sh` and `scripts/bootstrap.sh` restore the environment by applying:

- the portable config and AGENTS baseline
- the selected rules mode
- the exported direct custom skill payload
- the repository-owned shared agent profiles from `codex/os/common/agents/codex-agents/`

The restore path is profile-aware:

- if the current OS has its own native payload checked into `codex/os/<os>/runtime/`, that payload is used
- otherwise the scripts fall back to the primary exported payload

This keeps macOS, Linux, and Windows under a stable top-level layout without pretending that every OS already has its own native export snapshot.

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
- `codex/os/linux/runtime/`: current primary exported runtime payload
- `codex/os/macos/runtime/`: native macOS profile slot
- `codex/os/windows/runtime/`: native Windows profile slot
- `templates/`: reusable starter docs and policy templates derived from the baseline
- `scripts/`: operational lifecycle entrypoints

Each major module also carries a local `README.md` where the module boundary matters, so contributors can navigate by directory instead of inferring structure from scripts alone.

## Truth Boundaries

- If a change affects install or export behavior, `scripts/` and `docs/` must be updated together.
- If a change affects the baseline skill set, `codex/os/common/agents/`, `codex/os/linux/runtime/skills/`, and verification scripts must stay aligned.
- If a change affects runtime versions, `codex/os/linux/runtime/meta/toolchain.lock` and toolchain validation must remain consistent.
- If a native macOS or Windows payload is added, it must keep the same module boundaries as the Linux runtime payload.

## What This Repository Intentionally Does Not Mirror By Default

Portable export mode does not commit:

- auth secrets
- live session state
- command history
- transient runtime logs

Those belong to the machine runtime, not to the public repository baseline.
