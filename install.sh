#!/bin/bash

git clone --depth=1 https://github.com/z-Eduard005/dotfiles "$HOME"
cd "$HOME/dotfiles"
rm -rf .git README.md
rm -f "$HOME/.local/state/hypr/monitors"

if ! which stow &> /dev/null; then
    echo "stow could not be found, installing via dnf..."
    sudo dnf install -y stow
fi

stow */
# change all paths from home/eduard to $HOME
# Comment all in `export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card2"` in uwsm
rm install.sh
reboot