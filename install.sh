#!/bin/bash

# delete "$HOME/dotfiles" if it exists and promt user about it or just exit script!
git clone --depth=1 https://github.com/z-Eduard005/dotfiles "$HOME"
cd "$HOME/dotfiles"

if ! which stow &> /dev/null; then
    echo "stow could not be found, installing via dnf..."
    sudo dnf install -y stow
fi

stow */
# change all paths from home/eduard to $HOME
# Comment all in `export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card2"` in uwsm
rm -rf .git README.md install.sh
reboot