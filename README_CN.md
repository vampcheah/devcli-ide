# ghostty-devcli-ide

Ghostty + tmux 的 AI CLI 开发环境启动器，配合 Nautilus 右键菜单，在任意项目目录一键打开。

## 布局

```
┌──────────┬──────────┬──────────┐
│          │  kudzu   │ gitoto   │
│   CLI    ├──────────┴──────────┤
│ (左 40%) │         CMD         │
└──────────┴─────────────────────┘
```

- **左**：AI CLI（默认 Claude Code）
- **右上左**：kudzu 树形文件管理器
- **右上右**：gitoto，以 `gitoto --root <项目路径>` 启动
- **右下**：Shell

## 使用方式

```bash
# 当前目录
./dev-cli.sh

# 指定项目目录
./dev-cli.sh /path/to/project
```

或在 Nautilus 中右键文件夹 → **DevCli IDE**。

同一项目路径重复运行会直接附加到已有 tmux session，不会重复创建。

## 切换 AI CLI

编辑 `dev-cli.sh` 顶部两行：

```bash
CLI_CMD="claude"
CLI_ARGS="--dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official"
```

## 文件说明

| 文件 | 说明 |
| ---- | ---- |
| `dev-cli.sh` | 主启动脚本 |
| `bin/kudzu-open.sh` | kudzu 文件管理器的编辑器集成（tmux popup 打开文件） |
| `guide.md` | Ghostty / tmux 快捷键速查 |

## 右键菜单配置

| 文件 | 路径 |
| ---- | ---- |
| `.desktop` 注册 | `~/.local/share/applications/claude-ide.desktop` |
| Nautilus 脚本 | `~/.local/share/nautilus/scripts/DevCli IDE` |

修改菜单显示名称：改 `.desktop` 的 `Name=` 字段，同时重命名 Nautilus 脚本文件。

## 依赖

- [Ghostty](https://ghostty.org)
- tmux
- [kudzu](https://github.com/vampcheah/kudzu)（或其他文件管理器，改 `dev-cli.sh` 对应行）
- [gitoto](https://github.com/francischeah/gitoto)

## gitoto 配置

从本地仓库安装 `gitoto`：

```bash
cd /home/francischeah/Documents/projects/015_gitpanda
cargo install --path .
```

可选配置文件：

```text
~/.config/gitoto/config.toml
```

`dev-cli.sh` 会运行 `gitoto --root "$PROJECT_DIR"`，因此当前打开的项目路径会覆盖配置文件里的 `root_dirs`。全局 UI、监听和图谱偏好可以保留在配置文件中：

```toml
scan_depth = 2
excluded_repos = ["node_modules", ".cargo", "target"]

[watch]
debounce_ms = 500
poll_local_secs = 5
poll_fetch_secs = 30
max_concurrent_polls = 4
watch_exclude_dirs = ["node_modules", "target", ".build", "dist", "vendor"]

[ui]
frame_rate = 10
check_for_updates = false
update_position = "top-right"

[graph]
branches = "all"
label_max_len = 24
show_stats = true

[submodules]
ignore_dirty = false

[commit]
no_verify = false
```
