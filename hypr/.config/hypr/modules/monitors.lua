-- Monitor configuration only -- behaviour lives in lib/monitor-engine.lua.
-- To list available monitor modes -`hyprctl monitors all`

return require("lib.monitor-engine").setup({
  -- Fallback rules, applied before the saved layout.
  defaults = {
    { output = "",         mode = "preferred",     position = "auto",    scale = "1.0", bitdepth = 10 },
    { output = "eDP-1",    mode = "1920x1080@144", position = "-1920x0", scale = "1.0", bitdepth = 10 },
    { output = "HDMI-A-1", mode = "2560x1440@75",  position = "0x0",     scale = "1.0", bitdepth = 10 },
  },

  -- Connector + display name + its variants.
  presets = {
    laptop = {
      name = "Laptop",
      output = "eDP-1",
      external = false,
      variants = {
        high = { mode = "1920x1080@144", position = "-1920x0", scale = "1.0", bitdepth = 10, disabled = false },
        low = { mode = "1920x1080@60", position = "-1920x0", scale = "1.0", bitdepth = 10, disabled = false },
        disable = { disabled = true },
      },
    },
    monitor = {
      name = "Monitor",
      output = "HDMI-A-1",
      external = true,
      variants = {
        high = { mode = "2560x1440@75", position = "0x0", scale = "1.0", bitdepth = 10, disabled = false },
        low = { mode = "1920x1080@75", position = "0x0", scale = "1.0", bitdepth = 10, disabled = false },
        disable = { disabled = true },
      },
    },
  },

  -- Pick with dotfiles-pick-monitor-mode (SUPER + P).
  modes = {
    { laptop = "disable", monitor = "high" },
    { laptop = "disable", monitor = "low" },
    { laptop = "high",    monitor = "disable" },
    { laptop = "low",     monitor = "disable" },
    { laptop = "high",    monitor = "high" },
  },

  -- Automatic layouts when the external monitor is plugged/unplugged.
  dock = { laptop = "disable", monitor = "high" },
  undock = { laptop = "high", monitor = "disable" },
})
