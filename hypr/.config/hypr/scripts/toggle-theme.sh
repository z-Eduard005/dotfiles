#!/bin/bash
set -euo pipefail

current=$(gsettings get org.gnome.desktop.interface color-scheme)
THEME=dark

if [[ "$current" == "'prefer-dark'" ]]; then
  THEME=light
else
  THEME=dark
fi

# gsettings
gsettings set org.gnome.desktop.interface color-scheme "prefer-$THEME"

# waybar & swaync
ln -sfn "colors-$THEME.css" "$HOME/dotfiles/accent-styles-css/.config/accent-styles-css/colors/colors-active.css"
ln -sfn "icons-$THEME" "$HOME/dotfiles/waybar/.config/waybar/assets/icons-active"
systemctl --user restart waybar.service
swaync-client --reload-css >/dev/null

# nwg-drawer
DRAWER="$HOME/dotfiles/nwg-drawer/.config/nwg-drawer/drawer.css"
D_BG="alpha(#222226, 0.95)"; D_FG="#eeeeee"

if [ "$THEME" = "dark" ]; then
  D_BG="alpha(#222226, 0.95)"; D_FG="#eeeeee"
else
  D_BG="alpha(#ebebed, 0.95)"; D_FG="#2f2f34"
fi
if [ -f "$DRAWER" ]; then
  sed -i "/^window {/,/^}/ s/^\( *background-color: \).*/\1${D_BG};/" "$DRAWER" 2>/dev/null || true
  sed -i "/^label {/,/^}/ s/^\( *color: \).*/\1${D_FG};/" "$DRAWER" 2>/dev/null || true
  grep -qF "background-color: ${D_BG};" "$DRAWER" 2>/dev/null || printf '\nwindow {\n  background-color: %s;\n}\n' "$D_BG" >> "$DRAWER" 2>/dev/null || true
  grep -qF "color: ${D_FG};" "$DRAWER" 2>/dev/null || printf '\nlabel {\n  color: %s;\n}\n' "$D_FG" >> "$DRAWER" 2>/dev/null || true
fi

# kitty
set_kitty_keys() {
  local f="$1" v="$2" k
  shift 2
  [ -f "$f" ] || return 0
  for k in "$@"; do
    if grep -q "^$k " "$f" 2>/dev/null; then
      sed -i "s/^\($k \+\).*/\1${v}/" "$f" 2>/dev/null || true
    else
      echo "$k $v" >> "$f" 2>/dev/null || true
    fi
  done
}
set_kitty_keys "$HOME/dotfiles/kitty/.config/kitty/dark-theme.auto.conf" "#222226" background selection_foreground
set_kitty_keys "$HOME/dotfiles/kitty/.config/kitty/light-theme.auto.conf" "#eeeeee" selection_foreground 
set_kitty_keys "$HOME/dotfiles/kitty/.config/kitty/light-theme.auto.conf" "#222226" active_tab_foreground foreground

# vicinae
toml_set() {
  local f="$1" s="$2" k="$3" v="$4"
  [ -f "$f" ] || return 0
  if grep -q "^$k = " "$f" 2>/dev/null; then
    sed -i "s/^\($k = \).*/\1\"$v\"/" "$f" 2>/dev/null || true
  elif grep -q "^\[$s\]$" "$f" 2>/dev/null; then
    sed -i "/^\[$s\]$/a $k = \"$v\"" "$f" 2>/dev/null || true
  else
    { printf '\n[%s]\n%s = "%s"\n' "$s" "$k" "$v" >> "$f" 2>/dev/null; } || true
  fi
}
VICINAE_THEME="$HOME/dotfiles/vicinae/.local/share/vicinae/themes/adwaita-dynamic.toml"
V_VARIANT="dark"; V_INHERITS="vicinae-dark"; V_BG="#222226"; V_FG="#eeeeee"

if [ "$THEME" = "dark" ]; then
  V_VARIANT="dark"; V_INHERITS="vicinae-dark"; V_BG="#222226"; V_FG="#ebebed"
else
  V_VARIANT="light"; V_INHERITS="vicinae-light"; V_BG="#ebebed"; V_FG="#222226"
fi
toml_set "$VICINAE_THEME" "meta" "variant" "$V_VARIANT"
toml_set "$VICINAE_THEME" "meta" "inherits" "$V_INHERITS"
toml_set "$VICINAE_THEME" "colors.core" "background" "$V_BG"
toml_set "$VICINAE_THEME" "colors.core" "foreground" "$V_FG"
vicinae theme set adwaita-dynamic 2>/dev/null || true