#!/bin/bash
set -euo pipefail

readonly MAP="$HOME/.local/state/dotfiles/hypr/wallpaper-accent-map.txt"
readonly STATE="$HOME/.local/state/dotfiles/hypr/wallpaper-accent"

map_signature() {
  md5sum "$MAP" 2>/dev/null | cut -d' ' -f1 || true
}

main() {
  mkdir -p "$(dirname "$STATE")"

  local current accent
  current="$(awww query 2>/dev/null | grep -oP 'image: \K.*' | head -1 || true)"
  [[ -n "$current" ]] || exit 0

  if [[ "$current $(map_signature)" == "$(cat "$STATE" 2>/dev/null || true)" ]]; then
    exit 0
  fi

  accent="$(dotfiles-accent wallpaper-extract || true)"
  if [[ -n "$accent" ]]; then
    dotfiles-accent switch "$accent" || true
  fi

  # post-run hash is exactly what the next tick must compare against
  printf '%s %s\n' "$current" "$(map_signature)" > "$STATE"
}

main "$@"
