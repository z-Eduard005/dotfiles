#!/bin/bash
# Shared helpers for the Hyprland dotfiles scripts.

# has <command> - succeed when the command is installed.
has() {
  command -v "$1" >/dev/null 2>&1
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

# require_cmd <command>... - abort when any required command is missing.
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
