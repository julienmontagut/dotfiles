# aliases.zsh - Shell aliases

# =============================================================================
# Git
# =============================================================================

alias gia="git add"
alias gic="git commit"
alias gicm="git commit -m"
alias gica="git commit --amend --no-edit"
alias gip="git push"
alias gipf="git push --force-with-lease"
alias giu="git pull"
alias gif="git fetch"
alias gipr="git remote prune origin"
alias gis="git status"
alias gid="git diff"
alias gids="git diff --staged"
alias gil="git log --oneline -20"
alias gigr="git log --graph --all"
alias gico="git checkout"
alias gire="git restore"
alias girs="git restore --staged"
alias giwo="git worktree"

# bare `gib` lists all branches; anything else passes through to git branch
gib() {
    if [ $# -eq 0 ]; then
        git branch -a
    else
        git branch "$@"
    fi
}

# =============================================================================
# Navigation
# =============================================================================

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# =============================================================================
# Modern replacements
# =============================================================================

# eza (ls replacement)
if command -v eza &>/dev/null; then
    alias ls="eza --icons=auto"
    alias ll="eza -l --icons=auto"
    alias la="eza -la --icons=auto"
    alias lt="eza -T --icons=auto"
fi

# bat (cat replacement)
if command -v bat &>/dev/null; then
    alias cat="bat --paging=never"
fi

# =============================================================================
# Kubernetes
# =============================================================================

alias k="kubectl"
alias kx="kubectx"
alias kn="kubens"

# =============================================================================
# Editor
# =============================================================================

alias v="nvim"
alias vim="nvim"

# =============================================================================
# Misc
# =============================================================================

alias reload="source ~/.zshenv && source ~/.zshrc"
alias dotfiles="cd ~/.local/share/dotfiles"
