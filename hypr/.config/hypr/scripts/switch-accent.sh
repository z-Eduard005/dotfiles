#!/bin/bash
set -euo pipefail

THEME_DIR="$HOME/dotfiles/accent-styles-css/.config/accent-styles-css"
HYPR_THEME="$HOME/dotfiles/hypr/.config/hypr/modules/theme.d/override.conf"
ACCENTS=(
  blue:#3584e4
  teal:#2190a4
  green:#3a944a
  yellow:#c88800
  orange:#ed5b00
  red:#e62d42
  pink:#d56199
  purple:#9141ac
  slate:#6f8396
)

usage() {
  echo "usage: $(basename "$0") blue|teal|green|yellow|orange|red|pink|purple|slate" >&2
  exit 2
}

[ $# -eq 1 ] || usage
ACCENT="$1"
CSS="$THEME_DIR/accents/accent-$ACCENT.css"
[ -f "$CSS" ] || usage

HEX=""
for a in "${ACCENTS[@]}"; do
  if [ "${a%%:*}" = "$ACCENT" ]; then
    HEX="${a##*:}"
    break
  fi
done

# gsettings
gsettings set org.gnome.desktop.interface accent-color "$ACCENT"

# waybar & swaync
ln -sfn "accent-$ACCENT.css" "$THEME_DIR/accents/accent-active.css"
systemctl --user restart waybar.service
swaync-client --reload-css >/dev/null

# hyprland window border
border="${HEX#\#}"
if [ -n "$border" ]; then
  if ! grep -q '^general {' "$HYPR_THEME" 2>/dev/null; then
    printf 'general {\n  col.active_border = rgb(%s)\n}\n' "$border" >> "$HYPR_THEME" 2>/dev/null || true
  elif sed -n '/^general {/,/^}/p' "$HYPR_THEME" 2>/dev/null | grep -q '^ *col\.active_border *='; then
    sed -i "/^general {/,/^}/ s/^\( *col\.active_border *= *\).*/\1rgb(${border})/" "$HYPR_THEME" 2>/dev/null || true
  else
    sed -i "/^general {$/a \  col.active_border = rgb(${border})" "$HYPR_THEME" 2>/dev/null || true
  fi
fi

# gdm
GDM_DCONF="$HOME/dotfiles/.gdm/etc/dconf/db/gdm.d/01-gdm-custom"
if [ -f "$GDM_DCONF" ] && grep -q "^accent-color='" "$GDM_DCONF"; then
  sed -i "s/^\(accent-color='\)[a-z]*\('\)/\1${ACCENT}\2/" "$GDM_DCONF" 2>/dev/null || true
  sudo -n dconf update 2>/dev/null || true
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
if [ -n "$HEX" ]; then
  set_kitty_keys "$HOME/dotfiles/kitty/.config/kitty/dark-theme.auto.conf" "$HEX" cursor color6 selection_background active_tab_background
  set_kitty_keys "$HOME/dotfiles/kitty/.config/kitty/light-theme.auto.conf" "$HEX" cursor color6 selection_background active_tab_background
fi

# kitty workaround: dark theme does not update accent
if [ "$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)" = "'prefer-dark'" ]; then
  gsettings set org.gnome.desktop.interface color-scheme "prefer-light" 2>/dev/null || true
  sleep 0.1 2>/dev/null || true
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
fi

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
VICINAE_SETTINGS="$HOME/dotfiles/vicinae/.config/vicinae/settings.json"
ICON="Adwaita-$ACCENT"

if [ -n "$HEX" ]; then
  toml_set "$VICINAE_THEME" "colors.core" "accent" "$HEX"

  if [ -f "$VICINAE_SETTINGS" ] && [ -w "$VICINAE_SETTINGS" ] && command -v jq >/dev/null 2>&1; then
    JQ_D="$(mktemp -d 2>/dev/null)" || JQ_D=""
    if [ -n "$JQ_D" ]; then
      FIRST="$(grep -n -m1 '^{' "$VICINAE_SETTINGS" 2>/dev/null | cut -d: -f1)"
      if [ -n "$FIRST" ] \
        && head -n $((FIRST - 1)) "$VICINAE_SETTINGS" > "$JQ_D/head" 2>/dev/null \
        && tail -n +"$FIRST" "$VICINAE_SETTINGS" 2>/dev/null | jq --arg icon "$ICON" '.theme.dark.icon_theme = $icon | .theme.light.icon_theme = $icon | .theme.dark.name //= "adwaita-dynamic" | .theme.light.name //= "adwaita-dynamic"' > "$JQ_D/body" 2>/dev/null \
        && [ -s "$JQ_D/body" ] \
        && cat "$JQ_D/head" "$JQ_D/body" > "$JQ_D/full" 2>/dev/null \
        && ! cmp -s "$JQ_D/full" "$VICINAE_SETTINGS" 2>/dev/null \
        && cat "$JQ_D/full" > "$VICINAE_SETTINGS" 2>/dev/null; then
        : # settings updated (header comments preserved, write only on change)
      fi
      rm -rf "$JQ_D" 2>/dev/null || true
    fi
  fi
fi
vicinae theme set adwaita-dynamic 2>/dev/null || true

# hyprlock
LOCK_CONF="$HOME/dotfiles/hypr/.config/hypr/hyprlock.conf"
if [ -n "$border" ] && [ -f "$LOCK_CONF" ]; then
  if grep -q '^input-field {' "$LOCK_CONF" 2>/dev/null; then
    if sed -n '/^input-field {/,/^}/p' "$LOCK_CONF" 2>/dev/null | grep -q '^ *outer_color *= *rgb('; then
      sed -i "/^input-field {/,/^}/ s/^\( *outer_color *= *rgb(\)[^)]*/\1${border}/" "$LOCK_CONF" 2>/dev/null || true
    else
      sed -i "/^input-field {$/a \    outer_color = rgb(${border})" "$LOCK_CONF" 2>/dev/null || true
    fi
  else
    printf '\ninput-field {\n    outer_color = rgb(%s)\n}\n' "$border" >> "$LOCK_CONF" 2>/dev/null || true
  fi
fi

# telegram workaround: reload to take effect
flatpak kill org.telegram.desktop 2>/dev/null || true
hyprctl dispatch exec "[workspace 4 silent] ~/.config/hypr/scripts/entry-launch.sh org.telegram.desktop" 2>/dev/null || true

# hyprtoolkit
