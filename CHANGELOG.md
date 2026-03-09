# Changelog

All notable changes to `codex-cli-bootstrap` are documented in this file.

The format is based on Keep a Changelog principles and uses a simplified date-based style.

## v0.0.1 - 2026-02-26

### Added

- Initial public macOS baseline release
- Strict `codex/os/*` hierarchy for runtime payloads
- Shared agent profile split under `codex/os/common/agents/codex-agents`
- GitHub community health files, CI, Dependabot, `llms.txt`, and `llms-full.txt`

### Changed

- Repository structure aligned around direct files instead of packed runtime archives
- macOS config template hardened around `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`

## 2026-03-10

### Added

- Public OSS project files: `LICENSE`, `CONTRIBUTING.md`, `SECURITY.md`, `SUPPORT.md`, `CODE_OF_CONDUCT.md`, `GOVERNANCE.md`
- GitHub issue and pull request templates under `.github/`
- Module entrypoint docs for `docs/`, `codex/os/`, and `scripts/`
- In-repo wiki structure and architecture documentation
- `.github/CODEOWNERS` assigning repository review ownership to `@rldyourmnd`
- `scripts/check-repo-consistency.sh` and `scripts/build-release-bundle.sh`
- GitHub Release workflow for portable bundles

### Changed

- Repository governance and ownership wording aligned to Danil Silantyev (`rldyourmnd`), NDDev, and NDDev OpenNetwork
- Toolchain baseline synchronized to current runtime versions verified in March 2026
- Repository validation scripts updated to reflect the active skill set and os-first layout
- Curated skill baseline updated to include `openai-docs` and `gh-fix-ci`
- Direct custom skill payload updated to remove `code-reviewer`, `figma-implement-design`, and `security-ownership-map`
- Portable rules render path aligned with the curated manifest

### Removed

- `code-reviewer`
- `figma-implement-design`
- `security-ownership-map`
- Legacy root-level packed custom skill artifacts and stale archive-era path references
