#!/usr/bin/env bash
#
# dev-cli.sh — 在 Ghostty 中启动 tmux + AI CLI 开发环境
#
# 用法:
#   dev-cli.sh                    # 在当前目录启动
#   dev-cli.sh /path/to/project   # 在指定项目目录启动
#

set -euo pipefail

CLI_CMD="claude"
CLI_ARGS="--dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official"

PROJECT_DIR="${1:-$(pwd)}"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "错误: 目录不存在: $PROJECT_DIR"
    exit 1
fi

PROJECT_NAME="$(basename "$PROJECT_DIR")"
PATH_HASH="$(echo -n "$PROJECT_DIR" | md5sum | cut -c1-6)"
SESSION="dev-${PROJECT_NAME}-${PATH_HASH}"

# 如果已经在 tmux 内部，直接切换
if [[ -n "${TMUX:-}" ]]; then
    if tmux has-session -t "$SESSION" 2>/dev/null; then
        tmux switch-client -t "$SESSION"
    else
        echo "在 tmux 内不支持创建新 Ghostty 窗口，请在 tmux 外执行"
    fi
    exit 0
fi

# 如果 session 已存在，直接附加
if tmux has-session -t "$SESSION" 2>/dev/null; then
    exec ghostty -e tmux attach-session -t "$SESSION"
fi

# 布局
#   ┌──────────┬──────────┬──────────┐
#   │          │  kudzu   │ gitoto   │
#   │  Claude  ├──────────┴──────────┤
#   │          │         CMD         │
#   └──────────┴─────────────────────┘

# 使用 pane_id 而非索引，避免 tmux 版本差异导致的编号错位
tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR"
P_CLAUDE=$(tmux display-message -t "$SESSION" -p '#{pane_id}')

# Step 1: 水平分割，右侧 50% → 右列（稍后再分）
P_RIGHT=$(tmux split-window -h -l 60% -P -F '#{pane_id}' \
    -t "$P_CLAUDE" -c "$PROJECT_DIR")

# Step 2: 垂直分割右列，下面 30% 给 CMD
P_CMD=$(tmux split-window -v -l 30% -P -F '#{pane_id}' \
    -t "$P_RIGHT" -c "$PROJECT_DIR")

# Step 3: 水平分割右上（kudzu），右半边给 gitoto
P_KUDZU=$P_RIGHT
P_GITOTO=$(tmux split-window -h -l 75% -P -F '#{pane_id}' \
    -t "$P_KUDZU" -c "$PROJECT_DIR")

# 右上左: kudzu 树形文件管理器
tmux send-keys -t "$P_KUDZU" "kudzu \"$PROJECT_DIR\"" C-m

# 右上右: gitoto（以当前项目目录作为扫描根目录）
tmux send-keys -t "$P_GITOTO" "cd \"$PROJECT_DIR\" && gitoto --root \"$PROJECT_DIR\"" C-m

# 右下: CMD shell
tmux send-keys -t "$P_CMD" "cd \"$PROJECT_DIR\" && clear" C-m

# 窗口 resize 时按比例重算，避免 gitoto/CMD 被钉死导致 kudzu 吞掉增量
tmux set-hook -t "$SESSION" window-resized \
    "resize-pane -t $P_CLAUDE -x 40% ; resize-pane -t $P_CMD -y 30% ; resize-pane -t $P_GITOTO -x 45%"

# 焦点回到左侧，布局稳定后再启动 Claude（避免 TUI 渲染错位）
tmux select-pane -t "$P_CLAUDE"

# 设置 PATH 确保 bun 等工具可被插件（如 Telegram MCP server）找到
tmux send-keys -t "$P_CLAUDE" "export PATH=\"$HOME/.local/bin:$PATH\"" C-m

# 最后启动 CLI（确保终端尺寸已固定）
tmux send-keys -t "$P_CLAUDE" "$CLI_CMD $CLI_ARGS" C-m

exec ghostty -e tmux attach-session -t "$SESSION"
