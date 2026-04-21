# ghostty-devcli-ide

A Ghostty + tmux AI CLI development environment launcher. Integrates with the Nautilus right-click menu to open a full dev environment in any project directory with a single click.

## Layout

```
┌──────────┬──────────┬──────────┐
│          │  kudzu   │ lazygit  │
│   CLI    ├──────────┴──────────┤
│ (40% L)  │         CMD         │
└──────────┴─────────────────────┘
```

- **Left**: AI CLI (Claude Code by default)
- **Top-right left**: kudzu tree file manager
- **Top-right right**: lazygit
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

Edit the top two lines of `dev-cli.sh`:

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
- [kudzu](https://github.com/francoischeah/kudzu) (or another file manager — edit the relevant line in `dev-cli.sh`)
- lazygit
