#!/usr/bin/env bash
#
# git-aliases.sh
# Handy git aliases and small helper functions.
# Source this file from your shell (e.g. add to ~/.bashrc or ~/.zshrc):
#   source /path/to/git-aliases.sh
#
# Designed to be sourced, not executed directly.
#

# --- Aliases ---
alias gst='git status'
alias gstS='git status -s'
alias ga='git add'
alias gaa='git add --all'
alias gau='git add -u'
alias gap='git add -p'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -am'
alias gamend='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gsb='git switch -c'
alias gb='git branch'
alias gbr='git branch -vv'
alias gdel='git branch -D'
alias gl='git pull'
alias gp='git push'
alias gpo='git push origin'
alias gps='git push --set-upstream origin'
alias gpf='git push --force-with-lease'
alias gf='git fetch --all --prune'
alias grv='git remote -v'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate --all'
alias gll='git --no-pager log --stat --max-count=20'
alias gclean='git clean -fd'
alias gstash='git stash'
alias gsts='git stash list'
alias gsta='git stash apply'
alias gstp='git stash pop'
alias gblame='git blame -w'

# --- Helper functions ---

# Undo last commit but keep changes staged
gundo() {
    git reset --soft HEAD~1
    echo "Undid last commit; changes are staged."
}

# Show the last commit details
glast() {
    git --no-pager show --stat --pretty=fuller -1
}

# Recent commits (default 10)
grecent() {
    git log --oneline --graph --decorate --all -n "${1:-10}"
}

# Push current branch to origin and set upstream
gpset() {
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"
}

# Delete remote branch: gdelete-remote-branch origin/branch-name
gdelete-remote-branch() {
    if [ -z "$1" ]; then
        echo "Usage: gdelete-remote-branch <remote/branch>"
        return 1
    fi
    git push "${1%%/*}" --delete "${1#*/}"
}

# Confirm before cleaning (safer than gclean)
gclean-confirm() {
    echo "git clean -fd will remove untracked files and directories."
    read -p "Proceed? [y/N] " ans
    case "$ans" in
        [yY]*) git clean -fd ;;
        *) echo "Aborted" ;;
    esac
}

# Interactive rebase on N commits (default 3)
gri() {
    local n="${1:-3}"
    git rebase -i "HEAD~$n"
}

# Commit a fixup for a commit (`gfixup <commit-ish or HEAD~1>`)
gfixup() {
    if [ -z "$1" ]; then
        echo "Usage: gfixup <commit-ish>"
        return 1
    fi
    git commit --fixup "$1"
}

# Quick list of provided aliases and helpers
galiases() {
    cat <<'EOF'
Common git aliases provided:
    gst        git status
    gstS       git status -s
    ga, gaa    git add / git add --all
    gap        git add -p
    gcm        git commit -m
    gca        git commit -am
    gamend     git commit --amend --no-edit
    gco, gcb   checkout / checkout -b
    gb, gbr    git branch / git branch -vv
    glog       git log --oneline --graph --decorate --all
    glast      show the latest commit
    grecent    recent commits (default 10)
    gpset      push and set upstream to origin HEAD
    gclean-confirm  safe git clean -fd with confirmation
    gdelete-remote-branch origin/branch  delete a remote branch
    gri        interactive rebase on N commits (default 3)
EOF
}

# Prevent accidental execution as a script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This file is intended to be sourced: source ${BASH_SOURCE[0]}"
    exit 1
fi