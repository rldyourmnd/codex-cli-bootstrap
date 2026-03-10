# Changelog

All notable changes to `codex-cli-bootstrap` are documented in this file.

The format is based on Keep a Changelog principles and uses a simplified date-based style.

## v0.0.3 - 2026-03-11

### Changed

- Linux runtime config now mirrors the current Codex baseline with `personality = "pragmatic"`, `web_search = "live"`, explicit full-access automation settings, and remote Context7 header auth placeholders
- Shared agent/runtime policy now reflects the Chrome DevTools MCP browser baseline, `gpt-5.4` agent model routing, ripgrep fallback guidance, SSH command inputs, and stricter atomic GitHub commit guidance
- Export and activation scripts now understand token-header MCP auth for Context7 and GitHub instead of only older inline token patterns
- Portable setup and runtime docs now state that the current Codex CLI `--full-auto` alias is not treated as equivalent to the repository's exact full-access restore baseline
- Runtime metadata exports were refreshed for the current source-machine state, including empty project-trust snapshots and updated rule/toolchain captures

### Fixed

- `scripts/export-from-local.sh` now sanitizes both legacy and current Context7/GitHub auth shapes before writing portable config templates
- `scripts/check-repo-consistency.sh` now validates the active config baseline fields and ignores exported source-rule snapshots when checking for removed skills

## v0.0.1 - 2026-02-26

### Added

- Initial public macOS baseline release
- Strict `codex/os/*` hierarchy for runtime payloads
- Shared agent profile split under `codex/os/common/agents/codex-agents`
- GitHub community health files, CI, Dependabot, `llms.txt`, and `llms-full.txt`

### Changed

- Repository structure aligned around direct files instead of packed runtime archives
- macOS config template hardened around `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`

## v0.0.2 - 2026-03-10

### Added

- Public OSS project files: `LICENSE`, `CONTRIBUTING.md`, `SECURITY.md`, `SUPPORT.md`, `CODE_OF_CONDUCT.md`, `GOVERNANCE.md`
- GitHub issue and pull request templates under `.github/`
- Module entrypoint docs for `docs/`, `codex/os/`, and `scripts/`
- In-repo wiki structure and architecture documentation
- `.github/CODEOWNERS` assigning repository review ownership to `@rldyourmnd`
- `scripts/check-repo-consistency.sh` and `scripts/build-release-bundle.sh`
- GitHub Release workflow for portable bundles
- GitHub Discussions routing and README trust badges for public support discoverability
- Runtime module `README.md` files and reusable `templates/AGENTS.md`
- Repository-wide `.editorconfig` and `.gitattributes`

### Changed

- Repository governance and ownership wording aligned to Danil Silantyev (`rldyourmnd`), NDDev, and NDDev OpenNetwork
- Toolchain baseline synchronized to current runtime versions verified in March 2026
- Repository validation scripts updated to reflect the active skill set and os-first layout
- Curated skill baseline updated to include `openai-docs` and `gh-fix-ci`
- Direct custom skill payload updated to remove `code-reviewer`, `figma-implement-design`, and `security-ownership-map`
- Portable rules render path aligned with the curated manifest
- Linux and Windows setup docs normalized to stable canonical filenames
- Machine-readable discovery files refreshed to match the active runtime and support model
- CI expanded to include repository-owned agent audit before release bundle validation

### Removed

- `code-reviewer`
- `figma-implement-design`
- `security-ownership-map`
- Legacy root-level packed custom skill artifacts and stale archive-era path references
