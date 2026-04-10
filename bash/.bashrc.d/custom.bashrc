# alias
alias h=help
alias c=clear
alias cu=cursor
alias "ch"="git checkout"
alias "his"="history | grep"
alias gh-repos='gh api "user/repos?affiliation=owner,collaborator,organization_member&per_page=100" --paginate --jq ".[].full_name"'
