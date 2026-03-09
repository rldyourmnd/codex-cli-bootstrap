# better-codex

Portable Codex runtime baseline and public environment mirror for NDDev OpenNetwork.

This repository is the public source of truth for the reusable Codex setup maintained by Danil Silantyev (`rldyourmnd`), Global CEO of NDDev (`nddev.it.com`), with development driven by NDDev OpenNetwork (`on.nddev.it.com`).
It packages a reproducible Codex runtime baseline, repository-owned agent skills, sanitized configuration snapshots, and operator documentation so the same working environment can be restored across machines in a controlled way.

## Ownership

- Project owner and lead developer: Danil Silantyev (`rldyourmnd`)
- Organization: NDDev (`nddev.it.com`)
- Development initiative: NDDev OpenNetwork (`on.nddev.it.com`)
- Merge, release, branding, and governance authority stay with the project owner and maintainers delegated by the owner

## What This Repository Is

- A portable Codex environment mirror
- A repository of Codex-native agent skills and operational profiles
- A controlled export/import pipeline for `~/.codex`
- A public open-source project with reproducible setup and contribution rules

## Repository Modules

- [`docs/`](docs/README.md): canonical in-repo wiki and operator documentation
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md): repository architecture and data flow
- [`codex/`](codex/README.md): exported Codex artifacts, config templates, rule snapshots, and skill manifests
- [`scripts/`](scripts/README.md): export, install, bootstrap, verification, and OS-specific automation
- [`skills/`](skills/README.md): repository-owned Codex agent skill baseline
- [`templates/`](templates/README.md): reusable project templates derived from this baseline
- [`.github/`](.github): issue templates, PR template, Dependabot, and GitHub Actions workflows

## Documentation And Wiki

The canonical project wiki lives inside this repository under [`docs/`](docs/README.md).
Start here:

- [`docs/README.md`](docs/README.md): documentation home
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md): how export, install, and verification fit together
- [`docs/setup/README.md`](docs/setup/README.md): setup and restore guides
- [`docs/agents/README.md`](docs/agents/README.md): agent profile catalog
- [`codex/README.md`](codex/README.md): exported artifact layout
- [`scripts/README.md`](scripts/README.md): automation entrypoints
- [`skills/README.md`](skills/README.md): repository-owned skill baseline
- [`templates/README.md`](templates/README.md): reusable templates

## Open Source Project Files

- [`LICENSE`](LICENSE): project license
- [`CONTRIBUTING.md`](CONTRIBUTING.md): contribution and verification rules
- [`SECURITY.md`](SECURITY.md): vulnerability reporting policy
- [`SUPPORT.md`](SUPPORT.md): support and triage guidance
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md): collaboration standards
- [`GOVERNANCE.md`](GOVERNANCE.md): decision model and maintainer authority
- [`CHANGELOG.md`](CHANGELOG.md): repository change history

## CI/CD

This repository uses GitHub Actions only, which is the free and natural automation layer for a public open-source GitHub project.

- CI validates repository consistency and dry-runs release bundle creation
- Release automation builds a portable bundle and publishes it to GitHub Releases on version tags
- Dependabot tracks GitHub Actions dependency updates

Workflow entrypoints:

- [`.github/workflows/ci.yml`](.github/workflows/ci.yml)
- [`.github/workflows/release.yml`](.github/workflows/release.yml)
- [`.github/dependabot.yml`](.github/dependabot.yml)
- [`CODEOWNERS`](CODEOWNERS): review ownership defaults

## Exported Runtime Surface

The repository mirrors the portable parts of a Codex environment:

- `codex/config/config.template.toml`: sanitized global Codex config template
- `codex/agents/global.AGENTS.md`: exported global `~/.codex/AGENTS.md`
- `codex/rules/default.rules`: portable rules rendered from curated manifest
- `codex/rules/default.rules.source.snapshot`: source-machine rules snapshot
- `codex/skills/custom-skills.manifest.txt`: exact installed non-system skill list
- `codex/skills/custom-skills.tar.gz.b64`: packed non-system skill snapshot
- `codex/skills/custom-skills.sha256`: integrity checksum for packed skill snapshot
- `codex/skills/curated-manifest.txt`: curated upstream skill refresh set
- `codex/meta/toolchain.lock`: exported `codex/node/npm/python/uv/gh` versions
- `codex/config/projects.trust.snapshot.toml`: optional exported project trust entries
- `skills/codex-agents/*`: repository-owned baseline agent skills
- `codex/os/<os>/snapshots/full-home/`: optional OS-specific full-home snapshot location

Default export mode excludes runtime/session state such as auth, history, and transient logs.
Use `scripts/export-from-local.sh --with-full-home` only when you intentionally need an absolute machine snapshot for the same OS family.

## Quick Start

Canonical workflow:

- source-of-truth setup and restore guide: [`docs/setup/PORTABLE_SETUP.md`](docs/setup/PORTABLE_SETUP.md)
- operations and rollback guide: [`docs/setup/PROD_RUNBOOK.md`](docs/setup/PROD_RUNBOOK.md)

Source machine refresh:

```bash
scripts/export-from-local.sh
scripts/self-test.sh
```

Deterministic restore on a target machine:

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
scripts/bootstrap.sh --skip-curated
```

Post-restore validation:

```bash
scripts/check-toolchain.sh --strict-codex-only
scripts/verify.sh
scripts/audit-codex-agents.sh
scripts/codex-activate.sh --check-only
```

## Security And Secrets

Do not commit secrets, tokens, auth state, or private runtime logs.
Portable export mode redacts secret-like config values and preserves install placeholders for:

- `CONTEXT7_API_KEY`
- `GITHUB_MCP_TOKEN`

Read [`SECURITY.md`](SECURITY.md) before reporting vulnerabilities.

## Project Status Model

- Portable-safe mode is available for cross-machine transfer with reduced local coupling
- Exact parity mode is available for restoring a known-good environment baseline
- Full-home restore is optional and OS-specific by design

See [`docs/setup/PORTABLE_SETUP.md`](docs/setup/PORTABLE_SETUP.md) and [`docs/setup/PROD_RUNBOOK.md`](docs/setup/PROD_RUNBOOK.md) for the operational details.
