-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more
local state = require("modules.state")

hl.window_rule({
    match = { class = "zoom" },
    float = true,
})

-- update-system.sh runs a plain kitty; these rules float it at 75% on ws 5
hl.window_rule({
    match = { class = "update-system" },
    float = true,
    size = "monitor_w*0.75 monitor_h*0.75",
    workspace = "5",
})

if state.zen then
    -- zen: no border when a single tiled window is alone on the workspace
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
