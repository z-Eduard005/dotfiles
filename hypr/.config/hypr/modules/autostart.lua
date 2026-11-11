hl.on("hyprland.start", function()
  -- Services
  hl.exec_cmd("systemctl --user enable --now hypridle.service")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("systemctl --user enable --now waybar.service")
  hl.exec_cmd("systemctl --user enable --now waybar-signals.service")
  hl.exec_cmd("vicinae server")
  hl.exec_cmd("systemctl --user enable --now hyprsunset.service")
  hl.exec_cmd("gnome-software --gapplication-service")
  -- exec-once = /usr/libexec/evolution-calendar-factory -r # does not work

  -- SSH configuration
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("systemctl --user enable --now gcr-ssh-agent.socket")
  hl.exec_cmd("systemctl --user enable --now gnome-keyring-daemon.socket gnome-keyring-daemon.service")

  -- Inconsistent cursor fix
  hl.exec_cmd("hyprctl setcursor macOS 28")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'macOS'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 28")

  -- Applications
  hl.exec_cmd("dotfiles-entry-launch \"RUN_FASTFETCH=1 kitty\"", { workspace = "1 silent" })
  hl.exec_cmd("dotfiles-entry-launch cursor", { workspace = "2 silent" })
  hl.exec_cmd("dotfiles-entry-launch app.zen_browser.zen", { workspace = "3 silent" })
  hl.exec_cmd("dotfiles-entry-launch org.telegram.desktop", { workspace = "4 silent" })

  -- Other
  hl.exec_cmd("xmodmap -e \"keycode 108 = F3\"")
  hl.exec_cmd("~/.local/bin/hyprland-per-window-layout")
  hl.exec_cmd("dotfiles-watcher")
  hl.exec_cmd("dotfiles-youtube-notifier start")
end)
