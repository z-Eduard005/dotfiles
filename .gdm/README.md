# This package only can be `stow`-ed to root directory!
Use this command:
```
sudo stow -d "$HOME/dotfiles" -t / .gdm
printf '%s ALL=(root) NOPASSWD: /usr/bin/dconf update\n' "$(id -un)" | sudo tee /etc/sudoers.d/gdm-dconf-update >/dev/null
sudo chmod 0440 /etc/sudoers.d/gdm-dconf-update
sudo visudo -cf /etc/sudoers.d/gdm-dconf-update
sudo -n dconf update
```