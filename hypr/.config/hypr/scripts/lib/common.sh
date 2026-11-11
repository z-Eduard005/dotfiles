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

# Replace the first line matching <pattern> (an ERE) with <line>. When no line matches, insert <line> right after the first line containing <anchor>, or at the end of the file when there is no anchor either.
set_line() {
  local file="$1" pattern="$2" line="$3" anchor="${4:-}"
  local -a lines=()
  local i target=-1 text trailing_newline=1

  [[ -f "$file" ]] || die "missing config: $file"

  # Keep a missing final newline missing, so a no-op run leaves no diff.
  if [[ -n "$(tail -c 1 -- "$file")" ]]; then
    trailing_newline=0
  fi
  mapfile -t lines < "$file"

  for i in "${!lines[@]}"; do
    if [[ "${lines[i]}" =~ $pattern ]]; then
      target=$i
      break
    fi
  done

  if (( target >= 0 )); then
    lines[target]="$line"
  else
    target=-1
    if [[ -n "$anchor" ]]; then
      for i in "${!lines[@]}"; do
        if [[ "${lines[i]}" == *"$anchor"* ]]; then
          target=$i
          break
        fi
      done
    fi
    if (( target >= 0 )); then
      lines=("${lines[@]:0:target+1}" "$line" "${lines[@]:target+1}")
    else
      lines+=("$line")
    fi
  fi

  # Write through the path so a stow symlink keeps pointing at the repo file.
  if ((${#lines[@]})); then
    printf -v text '%s\n' "${lines[@]}"
    (( trailing_newline )) || text="${text%$'\n'}"
  else
    text=""
  fi
  printf '%s' "$text" > "$file"
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
