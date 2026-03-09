# macOS Runtime Payload

This directory is the canonical populated runtime payload for `codex-cli-bootstrap`.

## Modules

- `agents/`: exported global runtime policy snapshot
- `config/`: sanitized config templates and trust snapshot
- `meta/`: pinned toolchain metadata
- `rules/`: exact source snapshot plus rendered portable rules
- `skills/custom/`: direct custom skill payload
- `skills/manifests/`: canonical skill manifests that drive verification and rules rendering

## Truth Boundaries

- `config/config.template.toml` defines the portable config baseline.
- `rules/default.rules.source.snapshot` preserves the exported source-machine rules.
- `rules/default.rules` and `rules/default.rules.template` are derived outputs, not hand-maintained policy files.
- `meta/toolchain.lock` is the runtime version contract used by verification scripts.
- `skills/custom/` and `skills/manifests/custom-skills.manifest.txt` must stay in sync.
