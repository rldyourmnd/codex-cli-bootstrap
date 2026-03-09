# Changelog

All notable changes to `better-codex` should be documented in this file.

The format is based on Keep a Changelog principles and uses a simplified date-based style.

## 2026-03-10

### Added

- Public OSS project files: `LICENSE`, `CONTRIBUTING.md`, `SECURITY.md`, `SUPPORT.md`, `CODE_OF_CONDUCT.md`, `GOVERNANCE.md`
- GitHub issue and pull request templates under `.github/`
- Module entrypoint docs for `docs/`, `codex/`, `scripts/`, `skills/`, and `templates/`
- In-repo wiki structure and architecture documentation
- `CODEOWNERS` assigning repository review ownership to `@rldyourmnd`

### Changed

- Repository governance and ownership wording aligned to Danil Silantyev (`rldyourmnd`), NDDev, and NDDev OpenNetwork
- Toolchain baseline synchronized to current runtime versions verified in March 2026
- Repository validation scripts updated to reflect the active skill set
- Curated skill baseline updated to include `openai-docs` and `gh-fix-ci`
- Portable rules render path aligned with the curated manifest

### Removed

- `code-reviewer`
- `figma-implement-design`
- `security-ownership-map`
- Stale macOS full-home snapshot artifacts that no longer represented the active baseline
