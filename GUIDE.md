# Ghostty + tmux Control Guide

## Config File Locations

| Tool | Path |
| ---- | ---- |
| Ghostty | `~/.config/ghostty/config` |
| tmux | `~/.tmux.conf` |
| Dev script | `~/Documents/app/ghostty/dev-cli.sh` |

---

## tmux Prefix Key

The prefix key is set to **`Ctrl+A`** (the default `Ctrl+B` is disabled).

Double-tap `Ctrl+A` to pass it through to the underlying program (e.g. jump to start of line in bash readline).

> `<prefix>` refers to `Ctrl+A` throughout this guide.

---

## tmux Keyboard Shortcuts

### Splitting Panes

| Shortcut | Action |
| -------- | ------ |
| `<prefix>` `\|` | Vertical split (left/right), keeps current directory |
| `<prefix>` `-` | Horizontal split (top/bottom), keeps current directory |

### Pane Navigation (no prefix needed)

| Shortcut | Action |
| -------- | ------ |
| `Alt+←` | Focus left pane |
| `Alt+→` | Focus right pane |
| `Alt+↑` | Focus pane above |
| `Alt+↓` | Focus pane below |

### Pane Resizing

| Shortcut | Action |
| -------- | ------ |
| `<prefix>` `H` | Expand left by 5 columns |
| `<prefix>` `L` | Expand right by 5 columns |
| `<prefix>` `J` | Expand down by 3 rows |
| `<prefix>` `K` | Expand up by 3 rows |

> These bindings support `-r` (repeat) — hold the prefix and press the key repeatedly to keep resizing.

### Window Management

| Shortcut | Action |
| -------- | ------ |
| `<prefix>` `c` | New window |
| `<prefix>` `n` | Next window |
| `<prefix>` `p` | Previous window |
| `<prefix>` `<number>` | Jump to window by number |

### Vi Copy Mode

| Shortcut | Action |
| -------- | ------ |
| `<prefix>` `[` | Enter copy mode |
| `v` (in copy mode) | Start selection |
| `y` (in copy mode) | Copy selection and exit |
| `Escape` (in copy mode) | Cancel and exit copy mode |

### Miscellaneous

| Shortcut | Action |
| -------- | ------ |
| `<prefix>` `r` | Reload tmux config |
| `<prefix>` `d` | Detach session |
| `<prefix>` `s` | List all sessions |

---

## Ghostty Keyboard Shortcuts

### Tabs

| Shortcut | Action |
| -------- | ------ |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |
| `Ctrl+Shift+W` | Close current tab |
| `Alt+1` – `Alt+8` | Jump to tab by number |
| `Alt+9` | Jump to last tab |

### Splits (Ghostty native)

| Shortcut | Action |
| -------- | ------ |
| `Ctrl+Shift+O` | Split right |
| `Ctrl+Shift+E` | Split down |
| `Ctrl+Shift+Enter` | Toggle split zoom |
| `Ctrl+Alt+Arrow` | Navigate between splits |
| `Super+Ctrl+Shift+Arrow` | Resize split |

> When using tmux for pane management, Ghostty native splits are generally not needed.

### Window & Fullscreen

| Shortcut | Action |
| -------- | ------ |
| `Ctrl+Shift+N` | New window |
| `Ctrl+Enter` | Toggle fullscreen |
| `Ctrl+Shift+Q` | Quit Ghostty |
| `Alt+F4` | Close window |

### Clipboard

| Shortcut | Action |
| -------- | ------ |
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |
| `Ctrl+Insert` | Copy |
| `Shift+Insert` | Paste (selection) |

### Font Size

| Shortcut | Action |
| -------- | ------ |
| `Ctrl+=` / `Ctrl++` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size |

### Scrolling

| Shortcut | Action |
| -------- | ------ |
| `Shift+PageUp` | Scroll up one page |
| `Shift+PageDown` | Scroll down one page |
| `Shift+Home` | Scroll to top |
| `Shift+End` | Scroll to bottom |

### Other

| Shortcut | Action |
| -------- | ------ |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+I` | Developer inspector |
| `Ctrl+Shift+,` | Reload config |
| `Ctrl+,` | Open config file |
| `Ctrl+Shift+A` | Select all |

---

## dev-cli.sh Dev Environment

Run `dev-cli.sh [project-path]` to start a tmux session inside Ghostty with the following layout:

```
┌──────────┬──────────┬──────────┐
│          │  kudzu   │ gitoto   │
│   CLI    ├──────────┴──────────┤
│ (40% L)  │         CMD         │
└──────────┴─────────────────────┘
```

- **Left**: AI CLI launched automatically (controlled by variables at the top of the script)
- **Top-right left**: kudzu tree file manager
- **Top-right right**: gitoto, launched as `gitoto --root <project-path>`
- **Bottom-right**: Plain shell
- Use `Alt+←/→/↑/↓` to switch between panes
- Running the script again for the same path attaches to the existing session

### Switching the CLI

Two variables at the top of the script — change these to switch to a different AI CLI:

```bash
CLI_CMD="claude"
CLI_ARGS="--dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official"
```

---

## DevCli IDE Right-click Menu

Right-clicking a folder in Nautilus reveals a "DevCli IDE" option that calls `dev-cli.sh` under the hood. Configuration lives in two places:

| Config file | Path | Purpose |
| ----------- | ---- | ------- |
| `.desktop` file | `~/.local/share/applications/claude-ide.desktop` | Registers as an "Open With" option for directories |
| Nautilus script | `~/.local/share/nautilus/scripts/DevCli IDE` | Appears in right-click → Scripts submenu |

- To change the menu label: update `Name=` in the `.desktop` file and rename the Nautilus script to match
- To change launch behavior: only `dev-cli.sh` needs to be edited

---

## Current Ghostty Config Summary

- Font: JetBrains Mono 13pt, ligatures enabled
- Cursor: block, no blink
- Window: 6×4 padding, symmetric on both sides
- Clipboard: read and write both allowed

## Current tmux Config Summary

- Mouse support: enabled
- Window/pane numbering starts at 1
- Status bar: minimal style, shows session name, git branch, time
- Plugins: tmux-resurrect (session save), tmux-continuum (auto restore)
