# codex-cli-bootstrap

[![Release](https://img.shields.io/github/v/release/rldyourmnd/codex-cli-bootstrap?sort=semver)](https://github.com/rldyourmnd/codex-cli-bootstrap/releases)
[![CI](https://github.com/rldyourmnd/codex-cli-bootstrap/actions/workflows/ci.yml/badge.svg)](https://github.com/rldyourmnd/codex-cli-bootstrap/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Discussions](https://img.shields.io/github/discussions/rldyourmnd/codex-cli-bootstrap)](https://github.com/rldyourmnd/codex-cli-bootstrap/discussions)

Portable Codex CLI bootstrap and public runtime mirror for NDDev OpenNetwork.

`codex-cli-bootstrap` is the public source of truth for the reusable Codex environment maintained by Danil Silantyev (`rldyourmnd`), Global CEO of NDDev (`nddev.it.com`), with development executed through NDDev OpenNetwork (`on.nddev.it.com`).
It packages a reproducible Codex baseline, shared Codex agent profiles, sanitized `~/.codex` state, and operator documentation so the same environment can be restored on Ubuntu, macOS, and Windows with a stable repository hierarchy.

## What This Repository Is

- A public open source Codex bootstrap repository
- A direct-files mirror of the portable parts of `~/.codex`
- A strict split between repository-owned shared agents and exported custom skills
- A profile-aware restore surface for Linux, macOS, and Windows
- A GitHub-native distribution surface with CI, release bundles, and community health files

## Ownership

- Project owner and lead developer: Danil Silantyev (`rldyourmnd`)
- Organization: NDDev (`nddev.it.com`)
- Development initiative: NDDev OpenNetwork (`on.nddev.it.com`)
- Merge, release, branding, and governance authority stay with the project owner and maintainers delegated by the owner

## Runtime Baseline

- MCP baseline: `context7`, `sequential-thinking`, `github`, `shadcn`, `chrome-devtools`, `serena`
- Shared agent profiles: `9` under `codex/os/common/agents/codex-agents`
- Custom skills: `23` under `codex/os/linux/runtime/skills/custom`
- Config defaults: `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`
- Toolchain lock: Codex `0.112.0`, Node `25.8.0`, npm `11.11.0`, Python `3.14.3`, uv `0.10.9`, gh `2.87.3`

## OS Profile Model

Codex stores its portable state under `~/.codex`, including `config.toml`, `AGENTS.md`, and installed skills.
That makes the repository payload portable across platforms as long as each machine first installs the required CLI layer for its own OS.

This repository models that as three explicit layers:

- `codex/os/common/*`: repository-owned shared baseline used on every OS
- `codex/os/linux/runtime/*`: current primary exported payload from the source Linux machine
- `codex/os/macos/runtime/*` and `codex/os/windows/runtime/*`: native profile slots reserved for future native exports

`scripts/bootstrap.sh`, `scripts/install.sh`, and `scripts/verify.sh` resolve the requested OS profile first.
If a native payload for that OS is not checked in yet, they fall back to the current primary exported payload while keeping the top-level OS hierarchy stable.

## Repository Layout

- [`docs/README.md`](docs/README.md): canonical in-repo wiki
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md): structure and data-flow overview
- [`docs/setup/PROFILE_MATRIX.md`](docs/setup/PROFILE_MATRIX.md): OS support and payload matrix
- [`docs/setup/PORTABLE_SETUP.md`](docs/setup/PORTABLE_SETUP.md): restore and export workflow
- [`codex/README.md`](codex/README.md): exported Codex artifact namespace
- [`codex/os/README.md`](codex/os/README.md): OS profile layout and support model
- [`codex/os/linux/runtime/README.md`](codex/os/linux/runtime/README.md): current primary exported runtime payload
- [`codex/os/common/agents/README.md`](codex/os/common/agents/README.md): shared agent profile baseline
- [`scripts/README.md`](scripts/README.md): lifecycle entrypoints and validation flow
- [`scripts/os/README.md`](scripts/os/README.md): OS installer hierarchy
- [`templates/README.md`](templates/README.md): reusable starter templates
- [`.github/`](.github): issue templates, PR template, CODEOWNERS, Dependabot, and workflows

## Direct-Files Model

This repository uses an OS-first, direct-files layout instead of archives.

Primary exported payload:

- `codex/os/linux/runtime/README.md`
- `codex/os/linux/runtime/config/*`
- `codex/os/linux/runtime/agents/*`
- `codex/os/linux/runtime/rules/*`
- `codex/os/linux/runtime/meta/*`
- `codex/os/linux/runtime/skills/custom/*`
- `codex/os/linux/runtime/skills/manifests/*`

Shared cross-OS baseline:

- `codex/os/common/agents/codex-agents/*`

Staged native profile slots:

- `codex/os/macos/runtime/README.md`
- `codex/os/windows/runtime/README.md`

Each runtime root carries its own `README.md` so users can understand the hierarchy without scanning the entire tree.

## Quick Start

Canonical setup docs:

- [`docs/setup/PORTABLE_SETUP.md`](docs/setup/PORTABLE_SETUP.md)
- [`docs/setup/PROFILE_MATRIX.md`](docs/setup/PROFILE_MATRIX.md)
- [`docs/setup/os/linux.md`](docs/setup/os/linux.md)
- [`docs/setup/os/macos.md`](docs/setup/os/macos.md)
- [`docs/setup/os/windows.md`](docs/setup/os/windows.md)

Set required environment variables:

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
```

Restore the baseline on the target machine:

```bash
scripts/bootstrap.sh --skip-curated
```

Refresh the repository from a known-good source machine:

```bash
scripts/export-from-local.sh
scripts/self-test.sh
```

Validate the restored environment:

```bash
scripts/check-toolchain.sh --strict-codex-only
scripts/verify.sh
scripts/audit-codex-agents.sh
scripts/codex-activate.sh --check-only
```

## CI/CD

This project uses only free GitHub-native automation suitable for a public open source repository.

- CI validates repository consistency, agent-doc parity, and dry-runs the release bundle
- Release automation builds a tagged portable bundle and publishes it to GitHub Releases
- Dependabot keeps GitHub Actions dependencies current

Workflow entrypoints:

- [`.github/workflows/ci.yml`](.github/workflows/ci.yml)
- [`.github/workflows/release.yml`](.github/workflows/release.yml)
- [`.github/dependabot.yml`](.github/dependabot.yml)
- [`.github/CODEOWNERS`](.github/CODEOWNERS)

## Open Source Surface

- [`LICENSE`](LICENSE)
- [`CONTRIBUTING.md`](CONTRIBUTING.md)
- [`SECURITY.md`](SECURITY.md)
- [`SUPPORT.md`](SUPPORT.md)
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)
- [`GOVERNANCE.md`](GOVERNANCE.md)
- [`CHANGELOG.md`](CHANGELOG.md)
- [`CITATION.cff`](CITATION.cff)

## Support Paths

- Use GitHub Discussions for setup questions, usage guidance, and architecture conversations
- Use GitHub Issues for reproducible bugs, regressions, and feature requests
- Use [`SECURITY.md`](SECURITY.md) for vulnerabilities and sensitive reports

## Machine-Readable Discovery

- [`llms.txt`](llms.txt): concise retrieval index
- [`llms-full.txt`](llms-full.txt): expanded technical retrieval context

## Security

Do not commit secrets, tokens, auth state, or private runtime logs.
Portable export preserves placeholders for:

- `CONTEXT7_API_KEY`
- `GITHUB_MCP_TOKEN`

Read [`SECURITY.md`](SECURITY.md) before reporting vulnerabilities.
