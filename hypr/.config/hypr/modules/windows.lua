-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more
local state = require("lib.state")

-- no border on screenshots
hl.layer_rule({
  match = { namespace = "^(selection|hyprpicker)$" },
  no_anim = true,
})

hl.window_rule({
  match = { class = "zoom" },
  float = true,
})

hl.window_rule({
  match = { class = "update-system" },
  float = true,
  size = "monitor_w*0.75 monitor_h*0.75",
  workspace = "5",
})

hl.window_rule({
  match = { class = "^(app[.]zen_browser[.]zen|org[.]telegram[.]desktop)$" },
  focus_on_activate = true,
})

if state.zen then
  hl.window_rule({
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
  })
else
  hl.window_rule({
    match = { class = "(cursor|kitty|ai.opencode.desktop)" },
    opacity = "0.96",
  })
end
