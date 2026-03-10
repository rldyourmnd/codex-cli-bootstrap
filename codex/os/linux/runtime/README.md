# Linux Runtime Payload

This directory is the current primary exported runtime payload for `codex-cli-bootstrap`.
It was exported from the source Linux machine and is the active reference payload used by restore and verification flows today.

## Modules

- `agents/`: exported global runtime policy snapshot
- `config/`: sanitized config templates and trust snapshot
- `meta/`: pinned toolchain metadata
- `rules/`: exact source snapshot plus rendered portable rules
- `skills/custom/`: direct custom skill payload
- `skills/manifests/`: canonical skill manifests that drive verification and rules rendering

## Truth Boundaries

- `config/config.template.toml` defines the current portable config baseline.
- `config/config.template.toml` uses the remote Context7 MCP URL plus header placeholder and stores the full-access automation baseline explicitly instead of relying on the CLI `--full-auto` alias.
- The Linux Serena MCP entry in `config/config.template.toml` includes a small environment recovery wrapper so Codex-launched Serena sessions can still auto-open the web dashboard when GUI session variables are missing.
- `rules/default.rules.source.snapshot` preserves the exported source-machine rules.
- `rules/default.rules` and `rules/default.rules.template` are derived outputs, not hand-maintained policy files.
- `meta/toolchain.lock` is the runtime version contract used by verification scripts.
- `skills/custom/` and `skills/manifests/custom-skills.manifest.txt` must stay in sync.

## Cross-Platform Role

This payload is also the fallback portable payload for macOS and Windows restores until native exports for those profiles are checked in.
That works because the portable Codex state being mirrored here lives under the user's `~/.codex` home directory on every platform.
