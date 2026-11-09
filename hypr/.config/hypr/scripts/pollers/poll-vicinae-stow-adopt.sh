#!/bin/bash
# poll-vicinae-stow-adopt.sh — repair the stowed vicinae settings link.
set -euo pipefail

readonly LIVE="$HOME/.config/vicinae/settings.json"
readonly REPO="$HOME/dotfiles/vicinae/.config/vicinae/settings.json"

main() {
  [[ -f "$REPO" ]] || exit 0
  [[ ! -L "$LIVE" ]] || exit 0
  [[ -f "$LIVE" ]] && cat "$LIVE" > "$REPO" 2>/dev/null || true
  ln -sfn "$REPO" "$LIVE" 2>/dev/null || true
  exit 0
}

main "$@"
