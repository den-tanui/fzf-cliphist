# fzf-cliphist

A tmux popup interface for clipboard history management with fzf.

![fzf-cliphist popup](demo.gif)

## Features

- ⚡ Fast fuzzy search powered by fzf
- 👀 Preview clipboard content before copying
- 🖼️ Image support (optional)
- 🎨 Tokyo Night theme with customizable colors
- ⚙️ Fully configurable via tmux options
- 🔧 No external popup wrapper needed - uses native tmux `display-popup`

## Requirements

- [tmux](https://github.com/tmux/tmux) ≥ 3.2
- [cliphist](https://github.com/sentriz/cliphist) - Wayland clipboard manager
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) - Wayland clipboard utilities

## Clipboard Capture Setup

To capture clipboard contents, you need to run a background process that watches for clipboard changes:

### Bash/Zsh

Add to your `.bashrc` or `.zshrc`:

```bash
# Start cliphist store in background (runs on shell startup)
wl-paste --watch cliphist store &
```

### Systemd (recommended)

Create a user service for persistent capture:

```bash
mkdir -p ~/.config/systemd/user
```

Create `~/.config/systemd/user/cliphist.service`:

```ini
[Unit]
Description=Clipboard history capture

[Service]
ExecStart=/usr/bin/bash -c 'wl-paste --watch cliphist store'
Restart=on-failure

[Install]
WantedBy=default.target
```

Enable and start:

```bash
systemctl --user enable --now cliphist
```

### Sway/Waybar

Add to your sway config:

```
exec wl-paste --watch cliphist store
```

Or in waybar config:

```json
"custom/cliphist": {
    "exec": "wl-paste --watch cliphist store",
    "signal": 8
}
```

## Installation

## Installation

### Via Tmux Plugin Manager (Recommended)

Add to your `tmux.conf`:

```tmux
set -g @plugin 'den-tanui/fzf-cliphist'
```

Press `prefix + I` to install.

### Manual Installation

```bash
git clone https://github.com/den-tanui/fzf-cliphist ~/fzf-cliphist
```

Add to `tmux.conf`:

```tmux
run ~/fzf-cliphist/fzf-cliphist.tmux
```

Reload tmux: `tmux source-file ~/.tmux.conf`

## Usage

Press `M-h` (Alt+h) to open the clipboard history popup.

### Keybindings

| Key | Action |
|-----|--------|
| `Enter` | Copy selected item and exit |
| `Ctrl-y` | Copy without exiting |
| `Ctrl-p` | Toggle preview window |
| `Esc` | Cancel |

## Configuration

All options are configurable via tmux options:

```tmux
# Keybinding (default: M-h)
set -g @fzf-cliphist-bind "M-h"

# Popup dimensions (default: 80%)
set -g @fzf-cliphist-width "80%"
set -g @fzf-cliphist-height "80%"

# fzf options
set -g @fzf-cliphist-preview-window "right:50%:wrap"
set -g @fzf-cliphist-header "Enter: Copy | Ctrl-Y: Copy (no exit) | Ctrl-P: Toggle preview"
set -g @fzf-cliphist-color "fg:#c0caf5,bg:#1a1b26,hl:#e0af68,fg+:#c0caf5,bg+:#292e42,hl+:#e0af68,info:#7aa2f7"
```

### Show Images

By default, images are hidden. To include them:

```bash
fzf-cliphist --images
```

### Full Configuration Example

```tmux
# Key and popup
set -g @fzf-cliphist-bind "M-h"
set -g @fzf-cliphist-width "80%"
set -g @fzf-cliphist-height "80%"

# Custom colors (Tokyo Night)
set -g @fzf-cliphist-color "fg:#c0caf5,bg:#1a1b26,hl:#e0af68"

# Custom preview
set -g @fzf-cliphist-preview-window "right:60%:wrap"
set -g @fzf-cliphist-header "Select: Enter | Copy: Ctrl-y"
```

## How It Works

1. `cliphist list` fetches clipboard history
2. `fzf` provides fuzzy search interface
3. Selected item is decoded with `cliphist decode` and copied with `wl-copy`
4. Uses native tmux `display-popup` - no external wrapper needed

## Related

- [cliphist](https://github.com/sentriz/cliphist) - Clipboard manager
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [tmux-toggle-popup](https://github.com/loichyan/tmux-toggle-popup) - Inspiration

## License

MIT
