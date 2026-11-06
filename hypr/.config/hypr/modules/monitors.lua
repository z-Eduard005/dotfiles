-- Monitor configuration only -- behaviour lives in modules/lib/monitors.lua.
-- List available monitor modes -`hyprctl monitors all`

return require("lib.monitor-engine").setup({
  -- External output used for dock/undock detection.
  external = "HDMI-A-1",

  -- Fallback rules, applied before the saved layout.
  defaults = {
    { output = "",         mode = "preferred",     position = "auto",    scale = "1.0", bitdepth = 10 },
    { output = "eDP-1",    mode = "1920x1080@144", position = "-1920x0", scale = "1.0", bitdepth = 10 },
    { output = "HDMI-A-1", mode = "2560x1440@75",  position = "0x0",     scale = "1.0", bitdepth = 10 },
  },

  -- Which preset groups make up a layout, in order.
  layers = { "laptop", "monitor" },

  presets = {
    laptop = {
      high = { output = "eDP-1", mode = "1920x1080@144", position = "-1920x0", scale = "1.0", bitdepth = 10, disabled = false },
      low = { output = "eDP-1", mode = "1920x1080@60", position = "-1920x0", scale = "1.0", bitdepth = 10, disabled = false },
      disable = { output = "eDP-1", disabled = true },
    },
    monitor = {
      high = { output = "HDMI-A-1", mode = "2560x1440@75", position = "0x0", scale = "1.0", bitdepth = 10, disabled = false },
      low = { output = "HDMI-A-1", mode = "1920x1080@75", position = "0x0", scale = "1.0", bitdepth = 10, disabled = false },
      disable = { output = "HDMI-A-1", disabled = true },
    },
  },

  -- bind in keybinds.lua - hl.bind("KEY", monitors.cycle)
  cycle = {
    { laptop = "disable", monitor = "high",    notify = "monitor high, laptop disabled" },
    { laptop = "disable", monitor = "low",     notify = "monitor low, laptop disabled" },
    { laptop = "low",     monitor = "disable", notify = "monitor disabled, laptop low" },
    { laptop = "high",    monitor = "high",    notify = "monitor high, laptop high" },
  },

  -- Automatic layouts when the external monitor is plugged/unplugged.
  dock = { laptop = "disable", monitor = "high", notify = "monitor high, laptop disabled" },
  undock = { laptop = "high", monitor = "disable", notify = "monitor disabled, monitor high" },
})
