# Project Wiki

This directory is the canonical in-repo wiki for `codex-cli-bootstrap`.
It is intended to be the first place a human maintainer or contributor reads when they need to understand how the repository is organized, how the Codex environment is mirrored, and how to operate the project safely.

## Start Here

- [`../README.md`](../README.md): project overview and quick start
- [`ARCHITECTURE.md`](ARCHITECTURE.md): how the repository is structured and how state flows through it
- [`setup/README.md`](setup/README.md): installation, restore, OS profile, and runbook docs
- [`agents/README.md`](agents/README.md): repository-owned agent profile catalog

## Module Reference

- [`../codex/README.md`](../codex/README.md): top-level Codex artifact namespace
- [`../codex/os/README.md`](../codex/os/README.md): OS payload overview
- [`../codex/os/common/agents/README.md`](../codex/os/common/agents/README.md): shared agent profile baseline
- [`../scripts/README.md`](../scripts/README.md): automation entrypoints and lifecycle flow
- [`../scripts/os/README.md`](../scripts/os/README.md): OS installer hierarchy
- [`../templates/README.md`](../templates/README.md): reusable baseline templates for other repositories

## Community And Governance

- [`../CONTRIBUTING.md`](../CONTRIBUTING.md): contribution flow and required checks
- [`../SECURITY.md`](../SECURITY.md): vulnerability handling
- [`../SUPPORT.md`](../SUPPORT.md): support and issue routing
- [`../CODE_OF_CONDUCT.md`](../CODE_OF_CONDUCT.md): collaboration standards
- [`../GOVERNANCE.md`](../GOVERNANCE.md): ownership and decision model

## Reading Order

1. Read the root [`README.md`](../README.md).
2. Read [`ARCHITECTURE.md`](ARCHITECTURE.md) for the repository mental model.
3. Read [`setup/PROFILE_MATRIX.md`](setup/PROFILE_MATRIX.md) and [`setup/PORTABLE_SETUP.md`](setup/PORTABLE_SETUP.md) if you need to install or restore the environment.
4. Read [`../scripts/README.md`](../scripts/README.md) if you need to understand automation flow.
5. Read [`agents/README.md`](agents/README.md) and [`../codex/os/common/agents/README.md`](../codex/os/common/agents/README.md) if you need agent or skill context.
6. Read the community files in the repository root before contributing or reporting security issues.
