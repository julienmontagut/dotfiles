# aliases.zsh - Shell aliases

# =============================================================================
# Git
# =============================================================================

alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gpf="git push --force-with-lease"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline -20"
alias gco="git checkout"
alias gb="git branch"

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
