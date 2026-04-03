#!/bin/bash
# This rc is designed for optional stuff that I personally use. It's in its own
# file so it is less intrusive and can be easily sourced from a primary
# .bash_profile/.bashrc/etc.

# Needed for alacritty, tmux, and ssh.
export TERM=xterm-256color
export EDITOR=nvim
export CLICOLOR=1

# Tmux bash runs non login shell
if [ -x "$(command -v fzf)" ] && [ -x "$(command -v tmux)" ] && [ -n "$TMUX_PANE" ]; then
  ftpane() {
    local panes current_window current_pane target target_window target_pane
    panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
    current_pane=$(tmux display-message -p '#I:#P')
    current_window=$(tmux display-message -p '#I')

    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

    if [[ $current_window -eq $target_window ]]; then
      tmux select-pane -t ${target_window}.${target_pane}
    else
      tmux select-pane -t ${target_window}.${target_pane} &&
      tmux select-window -t $target_window
    fi
  }
fi

# macOS START ==================================================================
if [ -x "$(command -v brew)" ]; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  [ -f "$HOMEBREW_PREFIX/etc/bash_completion" ] && source "$HOMEBREW_PREFIX/etc/bash_completion"
  export PGDATA="$HOMEBREW_PREFIX/var/postgres"
else
  # Below is probably not in use, but keeping for reference.
  case $OSTYPE in
    darwin*) export PGDATA='/usr/local/var/postgres' ;;
  esac
fi
# macOS END ====================================================================

export COLORTERM=truecolor
[ -r "$HOME/.bashrcs/aliases.bash" ] && source "$HOME/.bashrcs/aliases.bash"
[ -r "$HOME/.fzf.bash" ] && [ -r "$HOME/.bashrcs/fzf.bash" ] && source "$HOME/.bashrcs/fzf.bash"

# Starship Prompt
if [ -x "$(command -v starship)" ]; then
  eval "$(starship init bash)"
fi
