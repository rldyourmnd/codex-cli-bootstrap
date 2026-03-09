# AGENTS.md - Repository Template

This template is a starter for repositories that want a Codex-first operating model similar to `codex-cli-bootstrap`.
Adapt the placeholders and remove any rule that does not fit the target repository.

## Core Rules

1. Think step by step and keep reasoning explicit.
2. Prefer correctness, clean architecture, and verifiable conclusions over speed.
3. Use primary-source documentation for anything freshness-sensitive.
4. Keep code, docs, and automation aligned when behavior changes.

## Tooling Workflow

1. Use Serena for code structure, symbol search, and references before falling back to raw text search.
2. Use Context7 before relying on external libraries, APIs, or framework behavior.
3. Use structured planning for multi-step changes and high-impact decisions.
4. Use repository scripts and existing templates before inventing new automation.

## Source Of Truth

1. `README.md` explains project scope and quick start.
2. `docs/` is the human-facing wiki.
3. Module-local `README.md` files explain directory ownership and hierarchy boundaries.
4. Machine-readable discovery files such as `llms.txt` or `llms-full.txt` should stay synchronized with human docs when they exist.

## Contribution Expectations

1. Keep commits atomic and use descriptive English commit messages.
2. Do not commit secrets, auth state, or transient local runtime artifacts.
3. Update tests, validation scripts, and docs together when changing behavior.
4. Prefer repository-native CI/CD and free GitHub-native OSS automation unless the project explicitly requires something else.
