#!/bin/bash

ICON_DIR="$HOME/.config/waybar/assets/icons"

vpn_active() {
    nmcli -t -f TYPE,STATE con show --active 2>/dev/null | grep -qE ':(vpn|wireguard):(connected|activated)' && return 0
    # standalone tunnels (wg-quick, openvpn CLI, tailscale, protonvpn app, zerotier, ppp)
    ip -o link show up 2>/dev/null | grep -qiE '^[0-9]+: (tun|wg|tailscale|proton|ppp|ipsec)[0-9]*:|vpn' && return 0
    return 1
}

wifi_iface=$(awk 'NR > 2 && $1 ~ /:$/ { sub(/:$/, "", $1); print $1; exit }' /proc/net/wireless 2>/dev/null)

if [ -z "$wifi_iface" ]; then
    if nmcli -t -f TYPE,STATE dev 2>/dev/null | grep -q "^ethernet:connected"; then
        if vpn_active; then
            echo "$ICON_DIR/wifi-cog.svg"
            echo "Ethernet (VPN)"
        else
            echo "$ICON_DIR/ethernet-port.svg"
            echo "Ethernet"
        fi
        exit 0
    fi
    if [ "$(nmcli radio wifi 2>/dev/null)" = "disabled" ]; then
        echo "$ICON_DIR/wifi-off.svg"
        echo "Wi-Fi disabled"
    else
        echo "$ICON_DIR/wifi-sync.svg"
        echo "Disconnected"
    fi
    exit 0
fi

quality=$(awk -v iface="$wifi_iface:" '$1 == iface {print int($3 * 100 / 70)}' /proc/net/wireless 2>/dev/null)
essid=$(nmcli -t -f NAME,TYPE con show --active 2>/dev/null | awk -F: '$2 ~ /wireless/ {print $1; exit}')

if [ "$quality" -le 25 ]; then
    icon="wifi-zero.svg"
elif [ "$quality" -le 50 ]; then
    icon="wifi-low.svg"
elif [ "$quality" -le 75 ]; then
    icon="wifi-high.svg"
else
    icon="wifi.svg"
fi

if vpn_active; then
    icon="wifi-cog.svg"
    suffix=" (VPN)"
fi

echo "$ICON_DIR/$icon"
echo "${essid:-Wi-Fi} ${quality}%${suffix:-}"
