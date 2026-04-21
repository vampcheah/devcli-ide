# Ghostty + tmux 操控指南

## 配置文件位置

| 工具    | 路径                                |
| ------- | ----------------------------------- |
| Ghostty | `~/.config/ghostty/config`          |
| tmux    | `~/.tmux.conf`                      |
| 开发脚本 | `~/Documents/app/ghostty/dev-cli.sh` |

---

## tmux 前缀键

前缀键已改为 **`Ctrl+A`**（默认的 `Ctrl+B` 已禁用）。

双击 `Ctrl+A` 可透传到程序（如 bash readline 跳到行首）。

> 以下用 `<prefix>` 代指 `Ctrl+A`。

---

## tmux 快捷键速查

### 窗口分割

| 快捷键           | 操作                   |
| ---------------- | ---------------------- |
| `<prefix>` `\|`  | 垂直分割（左右），保持当前目录 |
| `<prefix>` `-`   | 水平分割（上下），保持当前目录 |

### Pane 切换（无需前缀）

| 快捷键       | 操作       |
| ------------ | ---------- |
| `Alt+←`      | 切到左侧 Pane |
| `Alt+→`      | 切到右侧 Pane |
| `Alt+↑`      | 切到上方 Pane |
| `Alt+↓`      | 切到下方 Pane |

### Pane 大小调整

| 快捷键           | 操作              |
| ---------------- | ----------------- |
| `<prefix>` `H`   | 向左扩展 5 列     |
| `<prefix>` `L`   | 向右扩展 5 列     |
| `<prefix>` `J`   | 向下扩展 3 行     |
| `<prefix>` `K`   | 向上扩展 3 行     |

> 这些键支持 `-r`（repeat），按住前缀后可连续调整。

### 窗口管理

| 快捷键           | 操作         |
| ---------------- | ------------ |
| `<prefix>` `c`   | 新建窗口     |
| `<prefix>` `n`   | 下一个窗口   |
| `<prefix>` `p`   | 上一个窗口   |
| `<prefix>` `数字` | 跳转到对应窗口 |

### Vi 复制模式

| 快捷键                 | 操作                    |
| ---------------------- | ----------------------- |
| `<prefix>` `[`         | 进入复制模式            |
| `v`（复制模式内）       | 开始选择                |
| `y`（复制模式内）       | 复制选择内容并退出      |
| `Escape`（复制模式内）  | 取消并退出复制模式      |

### 其他

| 快捷键           | 操作                   |
| ---------------- | ---------------------- |
| `<prefix>` `r`   | 重载 tmux 配置         |
| `<prefix>` `d`   | 分离 session（detach） |
| `<prefix>` `s`   | 列出所有 session       |

---

## Ghostty 快捷键速查

### 标签页

| 快捷键              | 操作           |
| -------------------- | -------------- |
| `Ctrl+Shift+T`       | 新建标签页     |
| `Ctrl+Tab`           | 下一个标签页   |
| `Ctrl+Shift+Tab`     | 上一个标签页   |
| `Ctrl+Shift+W`       | 关闭当前标签页 |
| `Alt+1` ~ `Alt+8`    | 跳转到对应标签页 |
| `Alt+9`              | 跳转到最后一个标签页 |

### 分割（Ghostty 原生）

| 快捷键                           | 操作             |
| -------------------------------- | ---------------- |
| `Ctrl+Shift+O`                   | 右侧分割         |
| `Ctrl+Shift+E`                   | 下方分割         |
| `Ctrl+Shift+Enter`               | 切换分割缩放     |
| `Ctrl+Alt+方向键`                | 在分割间切换     |
| `Super+Ctrl+Shift+方向键`        | 调整分割大小     |

> 注意：使用 tmux 管理分割时，通常不需要 Ghostty 原生分割。

### 窗口与全屏

| 快捷键              | 操作           |
| -------------------- | -------------- |
| `Ctrl+Shift+N`       | 新建窗口       |
| `Ctrl+Enter`         | 切换全屏       |
| `Ctrl+Shift+Q`       | 退出 Ghostty   |
| `Alt+F4`             | 关闭窗口       |

### 剪贴板

| 快捷键              | 操作           |
| -------------------- | -------------- |
| `Ctrl+Shift+C`       | 复制           |
| `Ctrl+Shift+V`       | 粘贴           |
| `Ctrl+Insert`        | 复制           |
| `Shift+Insert`       | 粘贴（选区）   |

### 字体大小

| 快捷键              | 操作           |
| -------------------- | -------------- |
| `Ctrl+=` / `Ctrl++`  | 放大字体       |
| `Ctrl+-`             | 缩小字体       |
| `Ctrl+0`             | 重置字体大小   |

### 滚动

| 快捷键              | 操作             |
| -------------------- | ---------------- |
| `Shift+PageUp`       | 向上翻页         |
| `Shift+PageDown`     | 向下翻页         |
| `Shift+Home`         | 滚动到顶部       |
| `Shift+End`          | 滚动到底部       |

### 其他

| 快捷键              | 操作               |
| -------------------- | ------------------ |
| `Ctrl+Shift+P`       | 命令面板           |
| `Ctrl+Shift+I`       | 开发者检查器       |
| `Ctrl+Shift+,`       | 重载配置           |
| `Ctrl+,`             | 打开配置文件       |
| `Ctrl+Shift+A`       | 全选               |

---

## dev-cli.sh 开发环境

运行 `dev-cli.sh [项目路径]` 会在 Ghostty 内启动 tmux session，布局如下：

```
┌──────────┬──────────┬──────────┐
│          │  kudzu   │ lazygit  │
│   CLI    ├──────────┴──────────┤
│ (左 40%) │         CMD         │
└──────────┴─────────────────────┘
```

- **左**：自动启动 AI CLI（由脚本顶部变量控制）
- **右上左**：kudzu 树形文件管理器
- **右上右**：lazygit
- **右下**：普通 Shell
- 用 `Alt+←/→/↑/↓` 在 Pane 间切换
- 同一项目路径重复运行会直接附加到已有 session

### 切换 CLI

脚本顶部两个变量，改这里即可切换到其他 AI CLI：

```bash
CLI_CMD="claude"
CLI_ARGS="--dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official"
```

---

## DevCli IDE 右键菜单

在 Nautilus 文件夹上右键会出现"DevCli IDE"选项，底层调用 `dev-cli.sh`。配置位于两处：

| 配置文件 | 路径 | 作用 |
| -------- | ---- | ---- |
| `.desktop` 文件 | `~/.local/share/applications/claude-ide.desktop` | 注册为目录的"用其他应用打开"选项 |
| Nautilus 脚本 | `~/.local/share/nautilus/scripts/DevCli IDE` | 出现在右键 → "脚本" 子菜单 |

- 修改菜单显示名称：改 `.desktop` 的 `Name=` 字段，并重命名 Nautilus 脚本文件
- 修改启动逻辑：只需改 `dev-cli.sh`

---

## 当前 Ghostty 配置摘要

- 字体：JetBrains Mono 13pt，启用连字
- 光标：块状，不闪烁
- 窗口：内边距 6x4，两侧对称
- 剪贴板：读写均允许

## 当前 tmux 配置摘要

- 鼠标支持：开启
- 窗口/Pane 编号从 1 开始
- 状态栏：极简风格，显示 session 名、git 分支、时间
- 插件：tmux-resurrect（会话保存）、tmux-continuum（自动恢复）
