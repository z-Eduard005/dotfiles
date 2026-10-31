#!/bin/bash
set -euo pipefail

HYPR_THEME="$HOME/dotfiles/hypr/.config/hypr/modules/theme.d/override.conf"
ANIM_CONF="$HOME/dotfiles/hypr/.config/hypr/modules/animations.conf"
WINDOWS_CONF="$HOME/dotfiles/hypr/.config/hypr/modules/windows.conf"
KITTY_CONF="$HOME/dotfiles/kitty/.config/kitty/kitty.conf"
WAYBAR_CSS="$HOME/dotfiles/waybar/.config/waybar/style.css"
WAYBAR_LAYOUT="$HOME/dotfiles/waybar/.config/waybar/layout.jsonc"
WAYBAR_MODULES="$HOME/dotfiles/waybar/.config/waybar/modules.jsonc"
ZEN_STATE="$HOME/.local/state/hypr/zen-mode"

# hyprland gaps
set_key() {
  local block="$1" key="$2"
  if ! grep -q "^$block {" "$HYPR_THEME" 2>/dev/null; then
    printf '%s {\n  %s = 0\n}\n' "$block" "$key" >> "$HYPR_THEME"
  elif sed -n "/^$block {/,/^}/p" "$HYPR_THEME" 2>/dev/null | grep -q "^ *$key *="; then
    sed -i "/^$block {/,/^}/ s/^\( *\)$key *=.*/\1$key = 0/" "$HYPR_THEME"
  else
    sed -i "/^$block {/,/^}/ { /^}$/i \\
  $key = 0
}" "$HYPR_THEME"
  fi
}

zen="$(cat "$ZEN_STATE" 2>/dev/null || true)"
[ "$zen" = true ] || zen=false

if [ "$zen" = true ]; then
  sed -i -e '/^general {/,/^}/ { /^ *gaps_in *= *0$/d; /^ *gaps_out *= *0$/d }' \
         -e '/^decoration {/,/^}/ { /^ *rounding *= *0$/d }' "$HYPR_THEME"
  sed -i '/^\(general\|decoration\) {$/{N;/^\(general\|decoration\) {\n}$/d}' "$HYPR_THEME"
  zen=false
else
  set_key general gaps_in
  set_key general gaps_out
  set_key decoration rounding
  zen=true
fi

mkdir -p "$(dirname "$ZEN_STATE")"
printf '%s\n' "$zen" > "$ZEN_STATE"

# hyprland animations
set_animations() {
  local val="$1"
  [ -f "$ANIM_CONF" ] || return 0
  if sed -n '/^animations {/,/^}/p' "$ANIM_CONF" 2>/dev/null | grep -q '^ *enabled *='; then
    sed -i "/^animations {/,/^}/ s/^\( *\)enabled *=.*/\1enabled = $val/" "$ANIM_CONF"
  else
    sed -i "/^animations {$/a \  enabled = $val" "$ANIM_CONF"
  fi
}

if [ "$zen" = true ]; then
  set_animations false
else
  set_animations true
fi

# hyprland opacity
set_opacity_rules() {
  [ -f "$WINDOWS_CONF" ] || return 0
  if [ "$1" = off ]; then
    sed -i -E 's/^([[:space:]]*)(windowrule[[:space:]]*=[^#]*,[[:space:]]*opacity[[:space:]]+[0-9.]+[[:space:]]*)$/\1# \2/' "$WINDOWS_CONF"
  else
    sed -i -E 's/^([[:space:]]*)#[[:space:]]*(windowrule[[:space:]]*=[^#]*,[[:space:]]*opacity[[:space:]]+[0-9.]+[[:space:]]*)$/\1\2/' "$WINDOWS_CONF"
  fi
}

if [ "$zen" = true ]; then
  set_opacity_rules off
else
  set_opacity_rules on
fi

# hyprland single-window border
set_single_window_border() {
  [ -f "$WINDOWS_CONF" ] || return 0
  if [ "$1" = on ]; then
    sed -i -E 's/^([[:space:]]*)#[[:space:]]*(windowrule[[:space:]]*=[[:space:]]*border_size[[:space:]]+0,.*)$/\1\2/' "$WINDOWS_CONF"
  else
    sed -i -E 's/^([[:space:]]*)(windowrule[[:space:]]*=[[:space:]]*border_size[[:space:]]+0,.*)$/\1# \2/' "$WINDOWS_CONF"
  fi
}

if [ "$zen" = true ]; then
  set_single_window_border on
else
  set_single_window_border off
fi

hyprctl reload 2>/dev/null || true

# kitty cursor trail
set_cursor_trail() {
  [ -f "$KITTY_CONF" ] || return 0
  if grep -q '^[[:space:]]*cursor_trail[[:space:]]' "$KITTY_CONF"; then
    sed -i -E "s/^([[:space:]]*)cursor_trail[[:space:]]+[0-9]+/\1cursor_trail $1/" "$KITTY_CONF"
  else
    printf 'cursor_trail %s\n' "$1" >> "$KITTY_CONF"
  fi
  pkill -USR1 -x kitty 2>/dev/null || true
}

if [ "$zen" = true ]; then
  set_cursor_trail 0
else
  set_cursor_trail 3
fi

# waybar zen-mode css
set_waybar_zen_css() {
  [ -f "$WAYBAR_CSS" ] || return 0
  if [ "$1" = on ]; then
    sed -i -E 's|^([[:space:]]*)/\*[[:space:]]*(@import "zen-mode\.css";)[[:space:]]*\*/[[:space:]]*$|\1\2|' "$WAYBAR_CSS"
  else
    sed -i -E 's|^([[:space:]]*)(@import "zen-mode\.css";)[[:space:]]*$|\1/* \2 */|' "$WAYBAR_CSS"
  fi
}

# waybar sizes
set_waybar_sizes() {
  local height ws tray icon
  if [ "$1" = on ]; then
    height=34; ws=20; tray=18; icon=20
  else
    height=40; ws=24; tray=20; icon=24
  fi

  [ -f "$WAYBAR_LAYOUT" ] && sed -i -E "s/^([[:space:]]*\"height\"[[:space:]]*:[[:space:]]*)[0-9]+/\1${height}/" "$WAYBAR_LAYOUT"
  [ -f "$WAYBAR_MODULES" ] || return 0

  sed -i -E \
    -e "/^[[:space:]]*\"hyprland\/workspaces\"[[:space:]]*:[[:space:]]*\{/,/^[[:space:]]{0,2}\},?[[:space:]]*$/ s/^([[:space:]]*\"icon-size\"[[:space:]]*:[[:space:]]*)[0-9]+/\1${ws}/" \
    -e "/^[[:space:]]*\"tray\"[[:space:]]*:[[:space:]]*\{/,/^[[:space:]]{0,2}\},?[[:space:]]*$/ s/^([[:space:]]*\"icon-size\"[[:space:]]*:[[:space:]]*)[0-9]+/\1${tray}/" \
    -e "/^[[:space:]]*\"image#(temperature|volume|wifi|bluetooth|battery)\"[[:space:]]*:[[:space:]]*\{/,/^[[:space:]]{0,2}\},?[[:space:]]*$/ s/^([[:space:]]*\"size\"[[:space:]]*:[[:space:]]*)[0-9]+/\1${icon}/" \
    "$WAYBAR_MODULES"
}

if [ "$zen" = true ]; then
  set_waybar_zen_css on
  set_waybar_sizes on
else
  set_waybar_zen_css off
  set_waybar_sizes off
fi

pkill -USR2 -x waybar 2>/dev/null || true
