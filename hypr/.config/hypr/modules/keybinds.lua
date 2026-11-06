-- See https://wiki.hypr.land/Configuring/Keywords/

require("modules.fast-apps")

local monitors = require("modules.monitors")

-- Basic
hl.bind("ALT + W", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("CTRL + SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("nwg-drawer -nofs -nocats -ovl -is 128"))
hl.bind("CTRL + SHIFT + SLASH", hl.dsp.exec_cmd("pidof hyprpicker || hyprpicker -a"))
hl.bind("Print", hl.dsp.exec_cmd("dotfiles-screenshot"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind("SUPER + P", monitors.cycle)
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("handy --toggle-transcription"))
hl.bind("ALT + TAB", function()
  hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
  hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
end)

-- Disable middle click paste
hl.bind("mouse:274", hl.dsp.exec_cmd("wl-copy -pc"))

-- OBS recording hotkeys
hl.bind("CTRL + ALT + SHIFT + BACKSPACE", hl.dsp.exec_cmd("node ~/Programs/obs-hotkeys/toggle-record.js"))
hl.bind("CTRL + ALT + BACKSPACE", hl.dsp.exec_cmd("node ~/Programs/obs-hotkeys/toggle-pause.js"))

-- Vicinae
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("vicinae open"))
hl.bind("ALT + V", hl.dsp.exec_cmd("vicinae deeplink vicinae://launch/clipboard/history"))
hl.bind("CTRL + ALT + SPACE", hl.dsp.exec_cmd("vicinae server --replace"))

-- Move focus with arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with letters
hl.bind("SUPER + ALT + h", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + ALT + j", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + ALT + k", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + ALT + l", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + ALT + semicolon", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + ALT + apostrophe", hl.dsp.focus({ workspace = 6 }))

-- Move active window to a workspace
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + semicolon", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + apostrophe", hl.dsp.window.move({ workspace = 6 }))

-- Scroll through existing workspaces with arrows
hl.bind("SUPER + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + ALT + left", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 7%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 7%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
