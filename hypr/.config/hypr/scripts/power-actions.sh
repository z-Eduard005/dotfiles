#!/bin/bash
ACTION="${1:-}"

is_hyprland() {
    [[ "$XDG_CURRENT_DESKTOP" == *Hyprland* ]]
}

do_shutdown() {
    if is_hyprland; then
        hyprshutdown -t "Shutting down..." --post-cmd "shutdown -P 0"
    else
        gnome-session-quit --power-off
    fi
}

do_logout() {
    if is_hyprland; then
        hyprshutdown -t "Logging out..."
    else
        gnome-session-quit --logout
    fi
}

do_reboot() {
    if is_hyprland; then
        hyprshutdown -t "Rebooting..." --post-cmd "reboot"
    else
        gnome-session-quit --reboot
    fi
}

case "$ACTION" in
    shutdown)   do_shutdown ;;
    logout)     do_logout   ;;
    reboot)     do_reboot   ;;
    *)
        echo "Usage: $0 {shutdown|logout|reboot}"
        exit 1
        ;;
esac