# /Users/ramesh.rajendran/Developement/scripts/aliases/docker-aliases.sh
# Docker aliases and helper functions for zsh
# Source this file from ~/.zshrc (see below)

# Short commands
alias d='docker'
alias dc='docker compose'        # modern docker compose
alias dco='docker-compose'       # in case you still use docker-compose binary

# Listing
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpsf='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images'
alias dvol='docker volume ls'
alias dnet='docker network ls'

# Basic ops
alias dstart='docker start'
alias dstop='docker stop'
alias drestart='docker restart'
alias drm='docker rm'
alias drmf='docker rm -f'
alias drmi='docker rmi'
alias drmis='docker rmi -f'       # force remove images
alias dkill='docker kill'
alias dcp='docker cp'
alias dinspect='docker inspect'
alias dlogs='docker logs -f --tail 100'
alias dstats='docker stats --no-stream'
alias devents='docker events --since 1m'  # recent events

# Compose helpers
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose build --no-cache'
alias dcl='docker compose logs -f --tail 100'
alias dcr='docker compose run --rm'

# Common image/pull/push
alias dpull='docker pull'
alias dpush='docker push'
alias dsearch='docker search'

# Cleanup helpers (safe guards for empty lists)
dstopall() { [ -n "$(docker ps -q 2>/dev/null)" ] && docker stop $(docker ps -q); }
drmall()   { [ -n "$(docker ps -aq 2>/dev/null)" ] && docker rm -f $(docker ps -aq); }
drmi_all() { [ -n "$(docker images -q 2>/dev/null)" ] && docker rmi -f $(docker images -q); }
drmi_dangling() { local ids; ids="$(docker images -f dangling=true -q 2>/dev/null)"; [ -n "$ids" ] && docker rmi $ids; }

# Prune
dprune()       { docker system prune -af; }
dprune_images() { docker image prune -af; }
dprune_volumes() { docker volume prune -f; }
dprune_networks() { docker network prune -f; }

# Exec / shell helpers
dexec() { docker exec -it "$@"; }  # usage: dexec CONTAINER COMMAND...
dshell() {
    if [ -n "$1" ]; then
        docker exec -it "$1" /bin/sh 2>/dev/null || docker exec -it "$1" /bin/bash
    else
        local c
        c="$(docker ps -q | head -n1)"
        [ -n "$c" ] && docker exec -it "$c" /bin/sh 2>/dev/null || echo "No running containers"
    fi
}
dattach() { docker attach "$@"; }

# Logs with container name/autocomplete friendly
dl()  { docker logs -f --tail 100 "$@"; }
# Misc helpers
dcommit() { docker commit "$@"; }
dsave()   { docker save -o "$1" "${@:2}"; }  # usage: dsave out.tar image:tag
dload()   { docker load -i "$1"; }

# Enable completion/helpers to be available in interactive shells
if [ -n "$ZSH_VERSION" ]; then
    autoload -U compinit && compinit >/dev/null 2>&1
fi

# End of docker aliases