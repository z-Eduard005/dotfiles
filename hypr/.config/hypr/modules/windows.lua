-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more
local state = require("modules.state")

hl.window_rule({
    match = { class = "zoom" },
    float = true,
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
