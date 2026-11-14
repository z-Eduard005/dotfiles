-- https://wiki.hypr.land/Configuring/Variables/#general
local state = require("lib.state")

hl.config({
  general = {
    gaps_in = state.zen and 0 or 3,
    gaps_out = state.zen and 0 or 6,
    border_size = 2,

    -- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
    col = {
      active_border = state.accent,
      inactive_border = "rgba(595959aa)",
    },
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
    allow_tearing = false,
    layout = "dwindle",
  },
  -- https://wiki.hypr.land/Configuring/Variables/#decoration
  decoration = {
    rounding = state.zen and 0 or 6,
    rounding_power = 3,
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 4,
      color = "rgba(1a1a1aee)",
    },

    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      vibrancy = 0.1696,
    },
  },

  -- See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
  dwindle = {
    preserve_split = true, -- You probably want this
  },

  -- See https://wiki.hypr.land/Configuring/Master-Layout/ for more
  master = {
    new_status = "master",
  },

  -- https://wiki.hypr.land/Configuring/Variables/#misc
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    middle_click_paste = false,
  },
})
