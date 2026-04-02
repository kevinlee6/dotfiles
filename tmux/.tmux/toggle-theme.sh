#!/usr/bin/env bash

# Check current theme (default to light if not set)
CURRENT_THEME=$(tmux show-option -gqv @theme)

if [ -z "$CURRENT_THEME" ]; then
    CURRENT_THEME="light"
fi

if [ "$CURRENT_THEME" = "dark" ]; then
    # Switch to light
    tmux set-option -g @theme "light"
    tmux set-option -g window-style 'fg=colour240,bg=colour252'
    tmux set-option -g window-active-style 'fg=colour240,bg=colour255'
    tmux source-file ~/.tmux/papercolor-light.conf
    tmux display-message "Theme: PaperColor Light"
else
    # Switch to dark
    tmux set-option -g @theme "dark"
    tmux set-option -g window-style 'fg=colour250,bg=colour236'
    tmux set-option -g window-active-style 'fg=colour252,bg=colour234'
    tmux source-file ~/.tmux/papercolor-dark.conf
    tmux display-message "Theme: PaperColor Dark"
fi
