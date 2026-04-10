#!/bin/bash
NEW=0
[[ "$1" == "--new" ]] && NEW=1 && shift

NAME="$1"
DIRS=(
    "/usr/share/applications"
    "/usr/local/share/applications"
    "$HOME/.local/share/applications"
    "/var/lib/flatpak/exports/share/applications"
    "$HOME/.local/share/flatpak/exports/share/applications"
    "/var/lib/snapd/desktop/applications"
)

for dir in "${DIRS[@]}"; do
    FILE="$dir/$NAME.desktop"
    if [[ -f "$FILE" ]]; then
        EXEC=$(grep -m1 '^Exec=' "$FILE" | cut -d= -f2-)
        EXEC=$(echo "$EXEC" | sed 's/%[a-zA-Z]//g')

        BIN=$(basename "$(echo "$EXEC" | awk '{print $1}')")

        CLASS=$(grep -m1 '^StartupWMClass=' "$FILE" | cut -d= -f2-)
        [[ -z "$CLASS" ]] && CLASS="$NAME"
        [[ -z "$CLASS" ]] && CLASS="$BIN"
        
        if [[ "$NEW" -eq 0 ]]; then
            MATCH=$(hyprctl clients -j | jq -r ".[] | select(.class | ascii_downcase == \"${CLASS,,}\") | .address" | head -1)
            if [[ -z "$MATCH" ]]; then
                MATCH=$(hyprctl clients -j | jq -r ".[] | select(.class | ascii_downcase == \"${NAME,,}\") | .address" | head -1)
            fi
            if [[ -n "$MATCH" ]]; then
                hyprctl dispatch focuswindow "address:$MATCH"
                exit 0
            fi
        fi

        eval "set -- $EXEC"
        exec uwsm app -- "$@"
    fi
done

echo "Not found: $NAME" >&2
exit 1