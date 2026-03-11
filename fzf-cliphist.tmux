#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get options with defaults
BIND_KEY="$(tmux show-option -gqv @fzf-cliphist-bind)"
[ -z "$BIND_KEY" ] && BIND_KEY="C-h"

WIDTH="$(tmux show-option -gqv @fzf-cliphist-width)"
[ -z "$WIDTH" ] && WIDTH="80%"

HEIGHT="$(tmux show-option -gqv @fzf-cliphist-height)"
[ -z "$HEIGHT" ] && HEIGHT="80%"

# Paste to caller pane instead of using wl-copy
PASTE_TARGET="$(tmux show-option -gqv @fzf-cliphist-paste-target)"
[ -z "$PASTE_TARGET" ] && PASTE_TARGET="yes"

# FZF options
FZF_PREVIEW_WINDOW="$(tmux show-option -gqv @fzf-cliphist-preview-window)"
[ -z "$FZF_PREVIEW_WINDOW" ] && FZF_PREVIEW_WINDOW="right:50%:wrap"

FZF_HEADER="$(tmux show-option -gqv @fzf-cliphist-header)"
[ -z "$FZF_HEADER" ] && FZF_HEADER="Enter: Copy | Ctrl-Y: Copy (no exit) | Ctrl-P: Toggle preview"

FZF_COLOR="$(tmux show-option -gqv @fzf-cliphist-color)"
[ -z "$FZF_COLOR" ] && FZF_COLOR="fg:#c0caf5,bg:#1a1b26,hl:#e0af68,fg+:#c0caf5,bg+:#292e42,hl+:#e0af68,info:#7aa2f7"

# Build fzf-cliphist command with options
FZF_CLIPHIST_CMD="$CURRENT_DIR/bin/fzf-cliphist"
FZF_CLIPHIST_CMD="$FZF_CLIPHIST_CMD --preview-window '$FZF_PREVIEW_WINDOW'"
FZF_CLIPHIST_CMD="$FZF_CLIPHIST_CMD --header '$FZF_HEADER'"
FZF_CLIPHIST_CMD="$FZF_CLIPHIST_CMD --color '$FZF_COLOR'"
FZF_CLIPHIST_CMD="$FZF_CLIPHIST_CMD --paste-target '$PASTE_TARGET'"

# For paste-target=yes, we need to capture the target pane
if [ "$PASTE_TARGET" = "yes" ]; then
    # Use -t to specify target pane (the one that called the popup)
    tmux bind-key -T root "$BIND_KEY" display-popup -w "$WIDTH" -h "$HEIGHT" -t "{last}" -E "$FZF_CLIPHIST_CMD"
else
    tmux bind-key -T root "$BIND_KEY" display-popup -w "$WIDTH" -h "$HEIGHT" -E "$FZF_CLIPHIST_CMD"
fi
