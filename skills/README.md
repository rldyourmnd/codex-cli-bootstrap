# Skill Modules

This directory contains repository-owned Codex skill definitions.

## Current Layout

- `codex-agents/`: maintained baseline of project-owned agent skills

## Repository-Owned Baseline

The current baseline contains these agent skills:

- `better-explorer`
- `better-think`
- `better-plan`
- `better-code-review`
- `better-debugger`
- `manual-tester`
- `version-patrol`
- `serena-sync`
- `github-server-sync`

These skills are source-controlled in this repository and re-applied during install so that the repository-owned baseline remains authoritative even when a machine also restores a broader custom skill snapshot.

Read [`codex-agents/README.md`](codex-agents/README.md) for the agent-skill rationale and [`../docs/agents/README.md`](../docs/agents/README.md) for the operator-facing profile catalog.
