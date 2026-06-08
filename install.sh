#!/bin/bash

git clone --depth=1 https://github.com/z-Eduard005/dotfiles "/home/$USER"
cd "/home/$USER/dotfiles"
rm -rf .git README.md
echo "" > ./hypr/.config/hypr/modules/monitors.d/overwrite.conf

if ! which stow &> /dev/null; then
    echo "stow could not be found, installing via dnf..."
    sudo dnf install -y stow
fi

stow */
# change all paths from home/eduard to home/$USER
# Comment all in `export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card2"` in uwsm
# Comment monitor-watch.sh in autostart.conf
rm install.sh
reboot