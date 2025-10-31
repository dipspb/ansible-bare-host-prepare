alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'
alias md='mkdir -p'
alias rd=rmdir

alias dk=docker
alias dkc='docker compose'
alias dkrmc='for cnt in $(docker ps -q -f "status=created") ; do echo "removed $(docker rm -f $cnt)" ; done'
alias dkrme='for cnt in $(docker ps -q -f "status=exited") ; do echo "removed $(docker rm -f $cnt)" ; done'
alias dkrmi='docker rmi'

mkcd () {
	mkdir -p "$@" && cd "$@"
}

