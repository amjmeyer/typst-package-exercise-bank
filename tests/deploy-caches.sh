#!/usr/bin/env bash
# Copies the working tree into Typst's local and preview caches under the
# version in typst.toml, so docs/ and gallery/ -- which import
# @preview/exercise-bank:<version> -- compile against the code being
# released, instead of failing with "package not found" (that version isn't
# on the real Typst Universe registry until actually published).
#
# Covers both the regular cache and, if present, the one a Flatpak-sandboxed
# editor (e.g. VSCodium via Flatpak) uses instead -- these do not share a
# cache, so a version deployed only to the regular one still won't resolve
# from inside such an editor.
set -euo pipefail
cd "$(dirname "$0")/.."
pkg=exercise-bank
version=$(awk -F'"' '/^version/ {print $2; exit}' typst.toml)
dests=(
  "$HOME/.local/share/typst/packages/local/$pkg/$version"
  "$HOME/.cache/typst/packages/preview/$pkg/$version"
)
if [ -d "$HOME/.var/app/com.vscodium.codium/cache/typst" ]; then
  dests+=("$HOME/.var/app/com.vscodium.codium/cache/typst/packages/preview/$pkg/$version")
fi
for dest in "${dests[@]}"; do
  # A destination can be a stale symlink from an older layout: don't let
  # that block the others, which is what actually matters for
  # @preview/... imports to resolve.
  if ! mkdir -p "$dest" 2>&1; then
    echo "⚠ skip $dest (could not create)"
    continue
  fi
  rsync -a --delete ./ "$dest/" \
    --exclude='.git' --exclude='.claude' --exclude='docs' \
    --exclude='*.pdf' --exclude='tests' --exclude='gallery'
  echo "→ $dest"
done
