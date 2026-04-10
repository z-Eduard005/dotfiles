#!/bin/bash
FILENAME="$HOME/Pictures/Screenshots/ss_$(date +%Y-%m-%d_%H-%M-%S).png"
FROZEN="/tmp/frozen.png"

grim -l 0 $FROZEN
grim -l 0 -g "$(slurp -d)" $FILENAME < $FROZEN
wl-copy < $FILENAME