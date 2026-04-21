#!/usr/bin/env bash
# kudzu gui_editor wrapper: open file in tmux popup, fallback to direct editor outside tmux
set -euo pipefail

file="${1:-}"
[[ -z "$file" ]] && exit 1

editor="${VISUAL:-${EDITOR:-nano}}"

if [[ -z "${TMUX:-}" ]]; then
    exec "$editor" "$file"
fi

dir="$(dirname "$(realpath "$file")")"
tmux display-popup -E -w 90% -h 90% -d "$dir" -- "$editor" "$file"
