# upgrade-notice.zsh — banner when an Ubuntu LTS release upgrade is available.
# No-op on macOS, non-Ubuntu Linux, or when no upgrade is offered.
# Result is cached for 24h; refresh runs detached so shell startup stays instant.

() {
    [[ "$OSTYPE" == linux-gnu* ]] || return 0
    [[ -r /etc/os-release ]] || return 0

    local ID=""
    source /etc/os-release
    [[ "$ID" == ubuntu ]] || return 0
    (( $+commands[do-release-upgrade] )) || return 0

    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/upgrade-notice"
    local flag="$cache/ready" stamp="$cache/checked"
    [[ -d "$cache" ]] || mkdir -p "$cache"

    if [[ ! -f "$stamp" || -n "$(find "$stamp" -mtime +0 2>/dev/null)" ]]; then
        (
            if do-release-upgrade -c &>/dev/null; then
                : > "$flag"
            else
                rm -f "$flag"
            fi
            touch "$stamp"
        ) &!
    fi

    [[ -f "$flag" ]] || return 0

    print
    print -P "%F{yellow}%B>> Ubuntu LTS upgrade available — run: sudo do-release-upgrade%b%f"
    print
}
