-- See https://wiki.hypr.land/Configuring/Monitors/

-- Default
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1.0",
    bitdepth = 10,
})

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@144",
    position = "-1920x0",
    scale = "1.0",
    bitdepth = 10,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@75",
    position = "0x0",
    scale = "1.0",
    bitdepth = 10,
})

-- Runtime overrides, written by dotfiles-monitor-actions.
do
    local path = (os.getenv("HOME") or "") .. "/.local/state/dotfiles/hypr/monitors.lua"
    local f = io.open(path, "r")
    if f then
        local text = f:read("a")
        f:close()

        local chunk = load(text, "@" .. path, "t", {})
        local ok, specs = pcall(chunk)

        if ok and type(specs) == "table" then
            for _, spec in ipairs(specs) do
                if type(spec) == "table" and spec.output then
                    hl.monitor(spec)
                end
            end
        end
    end
end
