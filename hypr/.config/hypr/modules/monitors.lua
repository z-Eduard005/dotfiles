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

-- Runtime overrides, written by dotfiles-monitor-actions
-- Format is one `monitor=OUTPUT,MODE,POSITION,SCALE[,bitdepth,N]` per line,
-- or `monitor=OUTPUT,disable`. Missing file = keep the defaults above.
do
    local f = io.open((os.getenv("HOME") or "") .. "/.local/state/hypr/monitors", "r")
    if f then
        for line in f:lines() do
            local output, rest = line:match("^monitor=([^,]+),(.+)$")
            if output and rest == "disable" then
                hl.monitor({ output = output, disabled = true })
            elseif output then
                local mode, position, scale = rest:match("^([^,]+),([^,]+),([^,]+)")
                local bitdepth = rest:match(",bitdepth,(%d+)$")
                if mode then
                    hl.monitor({
                        output = output,
                        mode = mode,
                        position = position,
                        scale = scale,
                        bitdepth = bitdepth and tonumber(bitdepth) or nil,
                    })
                end
            end
        end
        f:close()
    end
end
