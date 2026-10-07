# alias
alias cu="cursor"
alias his="history | grep"
alias in="sudo dnf install"
alias remove="sudo dnf remove"
alias search="sudo dnf search"
alias update="sudo dnf upgrade --refresh && sudo flatpak update; fwupdmgr refresh --force >/dev/null 2>&1; fwupdmgr update -y"
alias ch="git checkout"
alias repos='gh api "user/repos?affiliation=owner,collaborator,organization_member&per_page=100" --paginate --jq ".[].full_name"'
alias fzf="fzf --height 40%"
alias l.="eza --icons -d .*"
alias ls="eza --icons -l"
alias l="eza --icons -lah"
alias ff="fastfetch"
alias c='clear && [ "$TERM" = "xterm-kitty" ] && ff; true'
alias cc="cd ~ && c"