#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/os/common/platform.sh"

OUTPUT_DIR="$ROOT_DIR/dist"
VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir)
      if [[ $# -lt 2 ]]; then
        echo "[ERROR] --output-dir requires a value"
        exit 1
      fi
      OUTPUT_DIR="$2"
      shift 2
      ;;
    --version)
      if [[ $# -lt 2 ]]; then
        echo "[ERROR] --version requires a value"
        exit 1
      fi
      VERSION="$2"
      shift 2
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      echo "Usage: scripts/build-release-bundle.sh [--output-dir <dir>] [--version <version>]"
      exit 1
      ;;
  esac
done

say() { echo "[RELEASE] $*"; }
err() { echo "[RELEASE][ERROR] $*" >&2; }

require_tool() {
  local tool="$1"
  if ! command -v "$tool" >/dev/null 2>&1; then
    err "Missing required tool: $tool"
    exit 1
  fi
}

for tool in tar awk find sort; do
  require_tool "$tool"
done

if [[ -z "$VERSION" ]]; then
  VERSION="$(git describe --tags --always 2>/dev/null || date -u +%Y%m%d%H%M%S)"
fi

mkdir -p "$OUTPUT_DIR"
bundle_name="better-codex-${VERSION}"
bundle_path="$OUTPUT_DIR/${bundle_name}.tar.gz"
checksum_path="$OUTPUT_DIR/${bundle_name}.sha256"
manifest_path="$OUTPUT_DIR/${bundle_name}.manifest.txt"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

find "$ROOT_DIR" -mindepth 1 -maxdepth 1 \
  ! -name '.git' \
  ! -name 'dist' \
  -exec cp -R {} "$tmpdir/" \;

if tar --help 2>/dev/null | grep -q -- '--sort'; then
  COPYFILE_DISABLE=1 tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner -C "$tmpdir" -czf "$bundle_path" .
else
  COPYFILE_DISABLE=1 tar -C "$tmpdir" -czf "$bundle_path" .
fi

sha256_file "$bundle_path" > "$checksum_path"
find "$tmpdir" -mindepth 1 | awk -v prefix="$tmpdir/" '{ sub("^" prefix, "", $0); print $0 }' | sort > "$manifest_path"

say "Created bundle: $bundle_path"
say "Created checksum: $checksum_path"
say "Created manifest: $manifest_path"
