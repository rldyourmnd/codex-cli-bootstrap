# Codex Agent Profiles

This directory defines Codex-native agent profiles for routing and role separation in `codex-cli-bootstrap`, the public Codex bootstrap repository maintained by Danil Silantyev (`rldyourmnd`) for NDDev and NDDev OpenNetwork (`on.nddev.it.com`).
Executable agent implementations are provided as skills in `codex/os/common/agents/codex-agents/*`.
Profile evolution, merge authority, and release curation stay with the project owner and NDDev maintainers.

Status model:

- `Active`: profile is implemented as a skill and installable now.
- `Hardened`: profile has validated runtime adapters and test evidence.

Global constraints for all profiles:

1. No mandatory external CLI orchestration.
2. No required `exec` wrappers as core behavior.
3. Prefer MCP + skills + repository scripts.
4. Produce auditable outputs.

Profiles:

- `better-explorer.md`
- `serena-sync.md`
- `version-patrol.md`
- `better-think.md`
- `better-plan.md`
- `better-code-review.md`
- `manual-tester.md`
- `better-debugger.md`
- `github-server-sync.md`

Skill install:

```bash
scripts/install-codex-agents.sh
```

Use this helper only when you want to install or refresh the repository-owned agent baseline by itself.
The canonical public restore flow for a full environment is `scripts/install.sh` or `scripts/bootstrap.sh`, which also applies exported config, rules, manifests, and custom skills from the os-first runtime layout.

Consistency audit:

```bash
scripts/audit-codex-agents.sh
```
