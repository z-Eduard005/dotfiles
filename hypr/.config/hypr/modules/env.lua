-- See https://wiki.hypr.land/Configuring/Environment-variables/

hl.config({
  ecosystem = {
    no_donation_nag = true,
  },
})

-- Cusor
hl.env("XCURSOR_PATH", "/home/eduard/.local/share/icons:/usr/share/icons")
hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_THEME", "macOS")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("QT_CURSOR_THEME", "macOS")
hl.env("QT_CURSOR_SIZE", "28")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Session
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
