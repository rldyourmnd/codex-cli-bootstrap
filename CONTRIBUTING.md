# Contributing

Thank you for contributing to `codex-cli-bootstrap`.

This repository is both an automation codebase and a public mirror of a working Codex environment.
Changes must preserve reproducibility, deterministic structure, safety, and documentation clarity.

## Before You Start

- Read [`README.md`](README.md), [`docs/README.md`](docs/README.md), and [`GOVERNANCE.md`](GOVERNANCE.md).
- Understand the current payload split:
  - shared agent profiles live under `codex/os/common/agents/codex-agents`
  - custom skills live under `codex/os/macos/runtime/skills/custom`
- Do not commit secrets, private auth state, or runtime logs.
- Keep changes focused and auditable.

## Contribution Rules

- Use English for code, docs, commit messages, and review discussions in the repository.
- Prefer atomic pull requests.
- Use conventional commit style where practical.
- Keep the `codex/os/*` hierarchy deterministic and path-consistent.
- Do not introduce overlap between shared agent profile names and custom skill names.
- Update documentation whenever behavior, structure, or operator workflow changes.
- If you change export/install/parity logic, update the relevant docs under `docs/` and module `README` files.

## Required Checks Before Opening A PR

Run the checks relevant to your change:

```bash
scripts/check-repo-consistency.sh
scripts/check-toolchain.sh --strict-codex-only
scripts/verify.sh
scripts/audit-codex-agents.sh
scripts/codex-activate.sh --check-only
```

If you changed export behavior, also run:

```bash
scripts/self-test.sh
```

If you changed release packaging or GitHub workflows, also run:

```bash
scripts/build-release-bundle.sh --output-dir dist
```

## Pull Request Expectations

- Explain what changed and why.
- Call out any portability impact.
- Call out any security impact.
- Call out rollback impact when behavior changed.
- Include documentation updates when structure or behavior changed.
- Do not remove repository-owned baseline skills or governance files without explicit maintainer approval.

## Review Authority

Final merge authority remains with Danil Silantyev (`rldyourmnd`), Global CEO of NDDev, and maintainers delegated by the owner.
