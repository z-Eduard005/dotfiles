# This package isnt supposed to be used with `stow` command!
Use this command instead:
```
sudo cp -r "$HOME/dotfiles/.fonts/usr/local/share/fonts/." "/usr/local/share/fonts/"
sudo fc-cache -f /usr/local/share/fonts
```