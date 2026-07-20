# Terminal file navigation helpers for Herdr panes and ordinary shells.
: "${QQ_HOME:=$HOME/projects/qq}"
function qq_mount_bin() {
    # Positional scratch avoids collisions with readonly caller variables.
    set -- "$PATH:" ""
    while [ -n "$1" ]; do
        if [ "${1%%:*}" = "$QQ_HOME/bin" ]; then
            set -- "${1#*:}" "$2"
        else
            set -- "${1#*:}" "$2:${1%%:*}"
        fi
    done
    PATH="$QQ_HOME/bin$2"
}
qq_mount_bin
unset -f qq_mount_bin
export PATH
function qqroot() {
    if [ -d "$QQ_HOME" ]; then
        builtin cd -- "$QQ_HOME"
    else
        printf 'QQ_HOME does not exist: %s\n' "$QQ_HOME" >&2
        return 1
    fi
}
function qq_space_dir() {
    local json dir
    command -v herdr >/dev/null 2>&1 || return 1
    command -v jq >/dev/null 2>&1 || return 1
    json="$(command herdr workspace list 2>/dev/null)" || return 1
    dir="$(command jq -r '[.result.workspaces[] | select(.focused == true) | .worktree.checkout_path // empty][0] // empty' <<<"$json" 2>/dev/null)" || return 1
    [ -n "$dir" ] && [ -d "$dir" ] || return 1
    printf '%s\n' "$dir"
}
function qqcd() {
    local dir
    if [ "$#" -eq 0 ]; then
        dir="$(qq_space_dir)" || dir="$QQ_HOME"
    else
        command -v fzf >/dev/null 2>&1 || { printf 'qqcd requires fzf\n' >&2; return 1; }
        dir="$(command find "$HOME" -type d 2>/dev/null | command fzf --query="$*")" || return
    fi
    builtin cd -- "$dir"
}
