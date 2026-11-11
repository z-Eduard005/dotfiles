#!/bin/bash
# Shared helpers for the dotfiles scripts.

has() {
  command -v "$1" >/dev/null 2>&1
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

require_cmd() {
  local cmd
  local -a missing=()
  for cmd in "$@"; do
    has "$cmd" || missing+=("$cmd")
  done
  ((${#missing[@]} == 0)) && return 0
  for cmd in "${missing[@]}"; do
    printf 'missing dependency: %s\n' "$cmd" >&2
  done
  exit 1
}

is_hyprland() {
  [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" || "${XDG_CURRENT_DESKTOP:-}" == *Hyprland* ]]
}

require_hyprland() {
  is_hyprland && return 0
  printf '%s only works under Hyprland\n' "$(basename "$0")" >&2
  exit 1
}

reap_stale_picker() {
  pgrep -f '^vicinae dmenu ' >/dev/null 2>&1 || return 0
  if vicinae state open >/dev/null 2>&1; then
    return 1
  fi
  pkill -f '^vicinae dmenu ' 2>/dev/null || true
}
