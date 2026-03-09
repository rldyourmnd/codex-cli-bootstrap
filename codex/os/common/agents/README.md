# Shared Agent Profiles

This directory contains the repository-owned Codex agent profiles shared across OS payloads.

## Current Layout

- `codex-agents/`: maintained baseline of project-owned agent skills

## Shared Baseline

The shared baseline contains these profiles:

- `better-explorer`
- `better-think`
- `better-plan`
- `better-code-review`
- `better-debugger`
- `manual-tester`
- `version-patrol`
- `serena-sync`
- `github-server-sync`

These skills are source-controlled in this repository and re-applied during install so the shared baseline remains authoritative even when a machine also restores a broader custom skill set.

Read [`codex-agents/README.md`](codex-agents/README.md) for the skill-level rationale and [`../../../../docs/agents/README.md`](../../../../docs/agents/README.md) for the operator-facing profile catalog.
