# ghostty-devcli-ide

A Ghostty + tmux AI CLI development environment launcher. Integrates with the Nautilus right-click menu to open a full dev environment in any project directory with a single click.

## Layout

```
┌──────────┬──────────┬──────────┐
│          │  kudzu   │ gitoto   │
│   CLI    ├──────────┴──────────┤
│ (40% L)  │         CMD         │
└──────────┴─────────────────────┘
```

- **Left**: AI CLI (Codex by default, using `--no-alt-screen` to keep tmux scrollback)
- **Top-right left**: kudzu tree file manager
- **Top-right right**: gitoto, launched as `gitoto --root <project-path>`
- **Bottom-right**: Shell

## Usage

```bash
# Current directory
./dev-cli.sh

# Specify a project directory
./dev-cli.sh /path/to/project
```

Or right-click a folder in Nautilus → **DevCli IDE**.

Running the script again for the same project path attaches to the existing tmux session instead of creating a new one.

## Switching the AI CLI

Default configuration:

```bash
CLI_CMD="codex"
CLI_ARGS="--no-alt-screen --dangerously-bypass-approvals-and-sandbox"
```

To switch to Claude Code, edit the top two lines of `dev-cli.sh`:

```bash
CLI_CMD="claude"
CLI_ARGS="--dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official"
```

## Files

| File | Description |
| ---- | ----------- |
| `dev-cli.sh` | Main launcher script |
| `bin/kudzu-open.sh` | Editor integration for kudzu — opens files in a tmux popup |
| `guide.md` | Ghostty / tmux keyboard shortcut reference |

## Right-click Menu Configuration

| File | Path |
| ---- | ---- |
| `.desktop` entry | `~/.local/share/applications/claude-ide.desktop` |
| Nautilus script | `~/.local/share/nautilus/scripts/DevCli IDE` |

To change the menu label: update the `Name=` field in the `.desktop` file and rename the Nautilus script to match.

## Dependencies

- [Ghostty](https://ghostty.org)
- tmux
- [kudzu](https://github.com/vampcheah/kudzu) (or another file manager — edit the relevant line in `dev-cli.sh`)
- [gitoto](https://github.com/francischeah/gitoto)

## gitoto Configuration

Install `gitoto` from the local repository:

```bash
cd /home/francischeah/Documents/projects/015_gitpanda
cargo install --path .
```

Optional config file:

```text
~/.config/gitoto/config.toml
```

`dev-cli.sh` runs `gitoto --root "$PROJECT_DIR"`, so the opened project path overrides `root_dirs` from the config file. Keep global UI/watch preferences in the config:

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
