# codex-cli-bootstrap

Portable Codex runtime baseline and public environment mirror for NDDev OpenNetwork.

`codex-cli-bootstrap` is the public source of truth for the reusable Codex setup maintained by Danil Silantyev (`rldyourmnd`), Global CEO of NDDev (`nddev.it.com`), with development executed through NDDev OpenNetwork (`on.nddev.it.com`).
It packages a reproducible Codex runtime baseline, shared Codex agent profiles, sanitized configuration snapshots, and operator documentation so the same working environment can be restored across machines in a controlled way.

## What This Repository Is

- A public open source Codex bootstrap repository
- A direct-files mirror of the portable parts of `~/.codex`
- A curated skill baseline with a strict split between shared agent profiles and custom skills
- A documented, validated, GitHub-native distribution surface for restore and release workflows

## Ownership

- Project owner and lead developer: Danil Silantyev (`rldyourmnd`)
- Organization: NDDev (`nddev.it.com`)
- Development initiative: NDDev OpenNetwork (`on.nddev.it.com`)
- Merge, release, branding, and governance authority stay with the project owner and maintainers delegated by the owner

## Runtime Baseline

- MCP baseline: `context7`, `sequential-thinking`, `github`, `shadcn`, `playwright`, `serena`
- Shared agent profiles: `9` under `codex/os/common/agents/codex-agents`
- Custom skills: `23` under `codex/os/macos/runtime/skills/custom`
- Config defaults: `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`
- Toolchain lock: Codex `0.112.0`, Node `25.8.0`, npm `11.11.0`, Python `3.14.3`, uv `0.10.9`, gh `2.87.3`

## Repository Layout

- [`docs/README.md`](docs/README.md): canonical in-repo wiki for operators and contributors
- [`docs/INDEX.md`](docs/INDEX.md): concise documentation index
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md): structure and data-flow overview
- [`codex/os/README.md`](codex/os/README.md): OS payload map
- [`codex/os/common/agents/README.md`](codex/os/common/agents/README.md): shared agent profile source of truth
- [`codex/os/macos/README.md`](codex/os/macos/README.md): canonical runtime payload root
- [`scripts/README.md`](scripts/README.md): automation entrypoints and verification flow
- [`.github/`](.github): issue templates, PR template, CODEOWNERS, Dependabot, and GitHub Actions workflows

## Direct-Files Model

This repository uses an os-first, direct-files layout. The canonical portable payload currently lives under:

- `codex/os/macos/runtime/config/*`
- `codex/os/macos/runtime/agents/*`
- `codex/os/macos/runtime/rules/*`
- `codex/os/macos/runtime/meta/*`
- `codex/os/macos/runtime/skills/custom/*`
- `codex/os/macos/runtime/skills/manifests/*`
- `codex/os/common/agents/codex-agents/*`

Linux and Windows directories are kept as explicit placeholders so the hierarchy stays stable as additional runtime payloads are added.

## Quick Start

Canonical setup docs:

- [`docs/setup/PORTABLE_SETUP.md`](docs/setup/PORTABLE_SETUP.md)
- [`docs/setup/PROD_RUNBOOK.md`](docs/setup/PROD_RUNBOOK.md)
- [`docs/setup/os/macos.md`](docs/setup/os/macos.md)

Refresh the repository from a known-good local machine:

```bash
scripts/export-from-local.sh
scripts/self-test.sh
```

Restore the baseline on a target machine:

```bash
export CONTEXT7_API_KEY='ctx7sk-...'
export GITHUB_MCP_TOKEN="$(gh auth token)"
scripts/bootstrap.sh --skip-curated
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

- CI validates repository consistency and dry-runs the release bundle
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

## Machine-Readable Discovery

- [`llms.txt`](llms.txt): concise retrieval index
- [`llms-full.txt`](llms-full.txt): expanded technical retrieval context

## Security

Do not commit secrets, tokens, auth state, or private runtime logs.
Portable export preserves placeholders for:

- `CONTEXT7_API_KEY`
- `GITHUB_MCP_TOKEN`

Read [`SECURITY.md`](SECURITY.md) before reporting vulnerabilities.
