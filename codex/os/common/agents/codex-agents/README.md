# Codex Agent Skills

This directory contains Codex-native agent implementations as skills for `codex-cli-bootstrap`, the public Codex bootstrap repository maintained by Danil Silantyev (`rldyourmnd`) for NDDev and NDDev OpenNetwork (`on.nddev.it.com`).
Skill curation, merge authority, and release distribution remain with the project owner and NDDev maintainers.

Why skills:
- Codex supports reusable specialization via `SKILL.md` (+ optional `agents/openai.yaml`).
- There is no separate stable custom-agent runtime manifest equivalent to Claude's agent files.

Each folder here is installable to `~/.codex/skills/<name>/`.

Installed agents:
- better-explorer
- serena-sync
- version-patrol
- better-think
- better-plan
- better-code-review
- manual-tester
- better-debugger
- github-server-sync

Policy:
- No mandatory external orchestration loops as a required runtime dependency.
- Prefer Codex MCP tools + skills + repository scripts.
