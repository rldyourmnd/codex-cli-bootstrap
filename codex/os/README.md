# OS Layout

## Shared payload

- `common/README.md`
- `common/agents/README.md`
- `common/agents/codex-agents/`

## Runtime payloads

- `linux/README.md`
- `linux/runtime/README.md`
- `macos/README.md`
- `macos/runtime/README.md`
- `windows/README.md`
- `windows/runtime/README.md`

## Support model

- `linux/runtime/` is the current primary exported payload
- `macos/runtime/` is the native macOS profile slot
- `windows/runtime/` is the native Windows profile slot

Bootstrap and install scripts first try the runtime that matches the current OS.
If that native runtime payload is not present yet, they fall back to the primary exported payload while preserving the same top-level OS hierarchy.
