#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get options with defaults
BIND_KEY="$(tmux show-option -gqv @fzf-cliphist-bind)"
[ -z "$BIND_KEY" ] && BIND_KEY="C-h"

WIDTH="$(tmux show-option -gqv @fzf-cliphist-width)"
[ -z "$WIDTH" ] && WIDTH="80%"

HEIGHT="$(tmux show-option -gqv @fzf-cliphist-height)"
[ -z "$HEIGHT" ] && HEIGHT="80%"

# Bind the key
tmux bind-key -T root "$BIND_KEY" display-popup -w "$WIDTH" -h "$HEIGHT" -E "$CURRENT_DIR/bin/fzf-cliphist"
