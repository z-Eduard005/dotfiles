-- See https://wiki.hypr.land/Configuring/Keywords/

-- Basic
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("dotfiles-settings cheatsheet"))                        -- [CHEATSHEET_DESC]: Show Keybind Cheatsheet
hl.bind("ALT + W", hl.dsp.window.close())                                                        -- [CHEATSHEET_DESC]: Close Focused Window
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))                                 -- [CHEATSHEET_DESC]: Toggle Floating Window
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))       -- [CHEATSHEET_DESC]: Toggle Fullscreen Window
hl.bind("CTRL + SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })) -- [CHEATSHEET_DESC]: Toggle Maximized Window
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("nwg-drawer -nofs -nocats -ovl -is 128"))              -- [CHEATSHEET_DESC]: Open Application Drawer
hl.bind("CTRL + SUPER + SLASH", hl.dsp.exec_cmd("pidof hyprpicker || hyprpicker -a"))            -- [CHEATSHEET_DESC]: Pick Color From Screen
hl.bind("Print", hl.dsp.exec_cmd("dotfiles-screenshot region"))                                  -- [CHEATSHEET_DESC]: Screenshot Selected Region
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dotfiles-screenshot last-region"))                      -- [CHEATSHEET_DESC]: Screenshot Previous Region
hl.bind("SUPER + S", hl.dsp.exec_cmd("swaync-client -t -sw"))                                    -- [CHEATSHEET_DESC]: Toggle Notification Panel
hl.bind("SUPER + P", hl.dsp.exec_cmd("dotfiles-pick-monitor-mode"))                              -- [CHEATSHEET_DESC]: Pick Monitor Layout Preset
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("vicinae deeplink vicinae://dictation/toggle"))         -- [CHEATSHEET_DESC]: Voice Transcription
hl.bind("ALT + TAB", function()
  hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
  hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
end) -- [CHEATSHEET_DESC]: Cycle Windows
hl.bind(
  "CTRL + SUPER + ALT + COMMA",
  hl.dsp.exec_cmd("XDG_CURRENT_DESKTOP=GNOME dotfiles-entry-launch org.gnome.Settings")
) -- HIDDEN

-- Disable middle click paste
hl.bind("mouse:274", hl.dsp.exec_cmd("wl-copy -pc")) -- HIDDEN

-- OBS recording hotkeys
hl.bind("CTRL + ALT + SHIFT + BACKSPACE", hl.dsp.exec_cmd("node ~/Programs/obs-hotkeys/toggle-record.js")) -- [CHEATSHEET_DESC]: Toggle OBS Recording
hl.bind("CTRL + ALT + BACKSPACE", hl.dsp.exec_cmd("node ~/Programs/obs-hotkeys/toggle-pause.js"))          -- [CHEATSHEET_DESC]: Toggle OBS Pause

-- Vicinae
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("vicinae open"))                                    -- [CHEATSHEET_DESC]: Open Vicinae Launcher
hl.bind("CTRL + ALT + SPACE", hl.dsp.exec_cmd("vicinae server --replace"))                 -- [CHEATSHEET_DESC]: Restart Vicinae
hl.bind("ALT + V", hl.dsp.exec_cmd("vicinae deeplink vicinae://launch/clipboard/history")) -- [CHEATSHEET_DESC]: Open Clipboard History

-- Move focus with arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))   -- [CHEATSHEET_DESC]: Focus Window Left
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" })) -- [CHEATSHEET_DESC]: Focus Window Right
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))       -- [CHEATSHEET_DESC]: Focus Window Up
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))   -- [CHEATSHEET_DESC]: Focus Window Down

-- Switch workspaces with letters
hl.bind("SUPER + ALT + h", hl.dsp.focus({ workspace = 1 }))          -- [CHEATSHEET_DESC]: Switch To Workspace 1
hl.bind("SUPER + ALT + j", hl.dsp.focus({ workspace = 2 }))          -- [CHEATSHEET_DESC]: Switch To Workspace 2
hl.bind("SUPER + ALT + k", hl.dsp.focus({ workspace = 3 }))          -- [CHEATSHEET_DESC]: Switch To Workspace 3
hl.bind("SUPER + ALT + l", hl.dsp.focus({ workspace = 4 }))          -- [CHEATSHEET_DESC]: Switch To Workspace 4
hl.bind("SUPER + ALT + semicolon", hl.dsp.focus({ workspace = 5 }))  -- [CHEATSHEET_DESC]: Switch To Workspace 5
hl.bind("SUPER + ALT + apostrophe", hl.dsp.focus({ workspace = 6 })) -- [CHEATSHEET_DESC]: Switch To Workspace 6

-- Move active window to a workspace
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ workspace = 1 }))          -- [CHEATSHEET_DESC]: Move Window To Workspace 1
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ workspace = 2 }))          -- [CHEATSHEET_DESC]: Move Window To Workspace 2
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ workspace = 3 }))          -- [CHEATSHEET_DESC]: Move Window To Workspace 3
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ workspace = 4 }))          -- [CHEATSHEET_DESC]: Move Window To Workspace 4
hl.bind("SUPER + SHIFT + semicolon", hl.dsp.window.move({ workspace = 5 }))  -- [CHEATSHEET_DESC]: Move Window To Workspace 5
hl.bind("SUPER + SHIFT + apostrophe", hl.dsp.window.move({ workspace = 6 })) -- [CHEATSHEET_DESC]: Move Window To Workspace 6

-- Scroll through existing workspaces with arrows
hl.bind("SUPER + ALT + right", hl.dsp.focus({ workspace = "e+1" })) -- [CHEATSHEET_DESC]: Switch To Next Workspace
hl.bind("SUPER + ALT + left", hl.dsp.focus({ workspace = "e-1" }))  -- [CHEATSHEET_DESC]: Switch To Previous Workspace

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())   -- [CHEATSHEET_DESC]: Move Window With Mouse Drag
hl.bind("SUPER + mouse:273", hl.dsp.window.resize()) -- [CHEATSHEET_DESC]: Resize Window With Mouse Drag

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 7%+"),
  { locked = true, repeating = true }
) -- [CHEATSHEET_DESC]: Increase Audio Volume
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 7%-"),
  { locked = true, repeating = true }
) -- [CHEATSHEET_DESC]: Decrease Audio Volume
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
) -- [CHEATSHEET_DESC]: Toggle Audio Mute
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
) -- [CHEATSHEET_DESC]: Toggle Microphone Mute
hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%+"),
  { locked = true, repeating = true }
) -- [CHEATSHEET_DESC]: Increase Screen Brightness
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%-"),
  { locked = true, repeating = true }
) -- [CHEATSHEET_DESC]: Decrease Screen Brightness

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })        -- [CHEATSHEET_DESC]: Play Next Track
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })    -- [CHEATSHEET_DESC]: Play Previous Track
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- [CHEATSHEET_DESC]: Play Or Pause
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })  -- [CHEATSHEET_DESC]: Play Or Pause

-- Fast apps
hl.bind("SUPER + 1", hl.dsp.exec_cmd("dotfiles-entry-launch \"RUN_FASTFETCH=1 kitty\""))               -- [CHEATSHEET_DESC]: Open Terminal
hl.bind("SUPER + 2", hl.dsp.exec_cmd("dotfiles-entry-launch org.gnome.Nautilus"))                      -- [CHEATSHEET_DESC]: Open File Manager
hl.bind("SUPER + 3", hl.dsp.exec_cmd("dotfiles-entry-launch org.gnome.Software"))                      -- [CHEATSHEET_DESC]: Open GNOME Software
hl.bind("SUPER + 4", hl.dsp.exec_cmd("dotfiles-entry-launch org.gnome.SystemMonitor"))                 -- [CHEATSHEET_DESC]: Open System Monitor
hl.bind("SUPER + 5", hl.dsp.exec_cmd("dotfiles-entry-launch youtube-music", { workspace = 5 }))        -- [CHEATSHEET_DESC]: Open YouTube Music
hl.bind("SUPER + 6", hl.dsp.exec_cmd("dotfiles-entry-launch org.signal.Signal", { workspace = 4 }))    -- [CHEATSHEET_DESC]: Open Signal
hl.bind("SUPER + 7", hl.dsp.exec_cmd("dotfiles-entry-launch org.telegram.desktop", { workspace = 4 })) -- [CHEATSHEET_DESC]: Open Telegram
hl.bind("SUPER + 8", hl.dsp.exec_cmd("dotfiles-entry-launch app.zen_browser.zen", { workspace = 3 }))  -- [CHEATSHEET_DESC]: Open Zen Browser
hl.bind("SUPER + 9", hl.dsp.exec_cmd("dotfiles-entry-launch cursor"))                                  -- [CHEATSHEET_DESC]: Open Cursor IDE
hl.bind("SUPER + 0", hl.dsp.exec_cmd("dotfiles-entry-launch md.obsidian.Obsidian"))                    -- [CHEATSHEET_DESC]: Open Obsidian

hl.bind("SUPER + CTRL + 1", hl.dsp.exec_cmd("dotfiles-entry-launch --new \"RUN_FASTFETCH=1 kitty\""))  -- [CHEATSHEET_DESC]: Open New Terminal
hl.bind("SUPER + CTRL + 2", hl.dsp.exec_cmd("dotfiles-entry-launch --new org.gnome.Nautilus"))         -- [CHEATSHEET_DESC]: Open New File Manager
hl.bind("SUPER + CTRL + 3", hl.dsp.exec_cmd("dotfiles-entry-launch --new org.gnome.Software"))         -- [CHEATSHEET_DESC]: Open New GNOME Software
hl.bind("SUPER + CTRL + 4", hl.dsp.exec_cmd("dotfiles-entry-launch --new org.gnome.SystemMonitor"))    -- [CHEATSHEET_DESC]: Open New System Monitor
hl.bind("SUPER + CTRL + 5", hl.dsp.exec_cmd("dotfiles-entry-launch --new youtube-music"))              -- [CHEATSHEET_DESC]: Open New YouTube Music
hl.bind("SUPER + CTRL + 6", hl.dsp.exec_cmd("dotfiles-entry-launch --new org.signal.Signal"))          -- [CHEATSHEET_DESC]: Open New Signal
hl.bind("SUPER + CTRL + 7", hl.dsp.exec_cmd("dotfiles-entry-launch --new org.telegram.desktop"))       -- [CHEATSHEET_DESC]: Open New Telegram
hl.bind("SUPER + CTRL + 8", hl.dsp.exec_cmd("dotfiles-entry-launch --new app.zen_browser.zen"))        -- [CHEATSHEET_DESC]: Open New Zen Browser
hl.bind("SUPER + CTRL + 9", hl.dsp.exec_cmd("dotfiles-entry-launch --new cursor"))                     -- [CHEATSHEET_DESC]: Open New Cursor IDE
hl.bind("SUPER + CTRL + 0", hl.dsp.exec_cmd("dotfiles-entry-launch --new md.obsidian.Obsidian"))       -- [CHEATSHEET_DESC]: Open New Obsidian
