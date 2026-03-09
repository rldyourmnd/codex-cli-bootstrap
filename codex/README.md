# Codex Artifact Layout

This directory contains the exported, portable representation of the Codex runtime baseline.

## Submodules

- `agents/`: exported global `AGENTS.md` snapshot
- `config/`: sanitized `config.toml` template and project trust snapshot
- `meta/`: toolchain lock and exported runtime versions
- `os/`: optional per-OS full-home snapshot locations
- `rules/`: portable rules, source snapshot, and portable template
- `skills/`: custom skill snapshot archive, checksum, exact manifest, and curated manifest

## Source-Of-Truth Rules

- `config.template.toml` is the portable configuration baseline
- `default.rules.source.snapshot` reflects the source machine's exact exported rules
- `default.rules` and `default.rules.template` are rendered from `skills/curated-manifest.txt`
- `custom-skills.manifest.txt` and `custom-skills.tar.gz.b64` reflect the exact local non-system skill set at export time
- `toolchain.lock` defines the expected runtime versions for strict parity checks

## Notes

- Full-home snapshots are optional and may be absent for some OS families until a matching export is intentionally produced.
- Placeholder directories under `os/` exist to keep repository layout stable across platforms.
- Portable artifacts in this directory are consumed by the lifecycle scripts documented in [`../scripts/README.md`](../scripts/README.md).
