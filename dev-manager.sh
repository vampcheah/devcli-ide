#!/bin/sh
# Interactively list and delete tmux sessions.

set -u

if ! command -v tmux >/dev/null 2>&1; then
    echo "Error: tmux is not installed or not available in PATH." >&2
    exit 1
fi

current_session=""
if [ -n "${TMUX:-}" ]; then
    current_session="$(tmux display-message -p '#S' 2>/dev/null || true)"
fi

list_sessions() {
    sessions="$(tmux list-sessions -F '#{session_name}' 2>/dev/null || true)"

    if [ -z "$sessions" ]; then
        echo "No tmux sessions found."
        return 1
    fi

    echo
    echo "tmux sessions:"

    number=1
    old_ifs=$IFS
    IFS='
'
    for session in $sessions; do
        details="$(
            tmux display-message -p -t "$session" \
                '#{session_windows} window(s) | #{?session_attached,attached,detached} | created #{t:session_created}' \
                2>/dev/null || echo "status unavailable"
        )"

        marker=""
        if [ "$session" = "$current_session" ]; then
            marker=" [current session]"
        fi

        printf '  %d) %s%s\n     %s\n' "$number" "$session" "$marker" "$details"
        number=$((number + 1))
    done
    IFS=$old_ifs

    session_count=$((number - 1))
    return 0
}

refresh() {
    echo "Refreshing the session list..."
    list_sessions
}

while list_sessions; do
    echo
    printf 'Enter a session number to delete (q=quit, r=refresh): '
    if ! IFS= read -r choice; then
        echo
        exit 0
    fi

    case "$choice" in
        r|R)
            refresh
            continue
            ;;
        q|Q|'')
            exit 0
            ;;
        *[!0-9]*)
            echo "Please enter a valid session number."
            continue
            ;;
    esac

    if [ "$choice" -lt 1 ] || [ "$choice" -gt "$session_count" ]; then
        echo "Number out of range. Enter a number from 1 to $session_count."
        continue
    fi

    target="$(printf '%s\n' "$sessions" | sed -n "${choice}p")"
    if [ -z "$target" ] || ! tmux has-session -t "$target" 2>/dev/null; then
        echo "That session no longer exists. Refreshing the list."
        continue
    fi

    printf 'Delete "%s"? All programs in this session will be terminated. [y/N] ' "$target"
    if ! IFS= read -r confirm; then
        echo
        exit 0
    fi

    case "$confirm" in
        y|Y|yes|YES|Yes)
            if tmux kill-session -t "$target"; then
                echo "Deleted: $target"
            else
                echo "Failed to delete: $target" >&2
            fi
            ;;
        *)
            echo "Cancelled."
            ;;
    esac
done
