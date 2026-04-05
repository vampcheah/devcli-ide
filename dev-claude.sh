#!/usr/bin/env bash
#
# dev-claude.sh — 在 Ghostty 中启动 tmux + Claude Code 开发环境
#
# 用法:
#   dev-claude.sh                    # 在当前目录启动
#   dev-claude.sh /path/to/project   # 在指定项目目录启动
#

set -euo pipefail

PROJECT_DIR="${1:-$(pwd)}"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "错误: 目录不存在: $PROJECT_DIR"
    exit 1
fi

PROJECT_NAME="$(basename "$PROJECT_DIR")"
SESSION="dev-${PROJECT_NAME}"

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

# 读取 tmux base-index（配置改为从 1 开始）
WIN=$(tmux show-options -gv base-index 2>/dev/null || echo 1)
PANE=$(tmux show-options -gv pane-base-index 2>/dev/null || echo 1)

# 布局
#   ┌──────────────────┬──────────────────┐
#   │                  │      Yazi        │
#   │   Claude Code    │   (右, 上 70%)   │
#   │     (左全高)     ├──────────────────┤
#   │                  │      CMD         │
#   │                  │   (右, 下 30%)   │
#   └──────────────────┴──────────────────┘

# 分割后 pane 编号的实际规律：
#   新建 session     → pane 1 (全屏)
#   h-split pane1    → pane1(左 Claude), pane2(右)
#   v-split pane2    → pane2(右上 Yazi), pane3(右下 CMD 新增)
P_CLAUDE=$PANE          # 左: Claude Code  (pane 1)
P_YAZI=$((PANE + 1))    # 右上: Yazi       (pane 2)
P_CMD=$((PANE + 2))     # 右下: CMD shell  (pane 3, v-split 右侧后新增)

tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR"

# Step 1: 水平分割，右侧 50%（pane1 左, pane2 右）
tmux split-window -h -t "$SESSION:$WIN.$P_CLAUDE" -p 50 -c "$PROJECT_DIR"

# Step 2: 垂直分割右侧，下面 30% 给 CMD
#   → pane2(右上 Yazi), pane3(右下 CMD 新增)
tmux split-window -v -t "$SESSION:$WIN.$P_YAZI" -p 30 -c "$PROJECT_DIR"

# 右上: Yazi 文件管理器（P_YAZI = pane2）
tmux send-keys -t "$SESSION:$WIN.$P_YAZI" \
    "export PATH=\"$HOME/.cargo/bin:\$PATH\" && yazi \"$PROJECT_DIR\"" C-m

# 右下: CMD shell（P_CMD = pane3）停在项目目录
tmux send-keys -t "$SESSION:$WIN.$P_CMD" "cd \"$PROJECT_DIR\" && clear" C-m

# 焦点回到左侧，布局稳定后再启动 Claude（避免 TUI 渲染错位）
tmux select-pane -t "$SESSION:$WIN.$P_CLAUDE"

# 设置 PATH 确保 bun 等工具可被插件（如 Telegram MCP server）找到
tmux send-keys -t "$SESSION:$WIN.$P_CLAUDE" "export PATH=\"$HOME/.local/bin:$PATH\"" C-m

# 最后启动 Claude Code（确保终端尺寸已固定）
tmux send-keys -t "$SESSION:$WIN.$P_CLAUDE" "claude" Space "--dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official" C-m

exec ghostty -e tmux attach-session -t "$SESSION"
