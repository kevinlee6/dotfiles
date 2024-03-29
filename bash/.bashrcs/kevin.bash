#!/bin/bash
# This rc is designed for optional stuff that I personally use. It's in its own
# file so it is less intrusive and can be easily sourced from a primary
# .bash_profile/.bashrc/etc.

# Set prompt
PS1="\[\e[0;32m\]\u@\h:\w>\[\e[m\] "
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
  [ -f "$(brew --prefix)/etc/bash_completion" ] && source "$(brew --prefix)/etc/bash_completion"

  if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
    GIT_PROMPT_ONLY_IN_REPO=1
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
  fi

  export PGDATA="$(brew --prefix)/var/postgres"
else
  # Below is probably not in use, but keeping for reference.
  case $OSTYPE in
    darwin*) export PGDATA='/usr/local/var/postgres' ;;
  esac
fi
# macOS END ====================================================================

# Linux START ==================================================================
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_THEME=Single_line_Solarized
  source $HOME/.bash-git-prompt/gitprompt.sh
fi
# Linux END ====================================================================

[ -r ~/.bashrcs/aliases.bash ] && source ~/.bashrcs/aliases.bash
[ -r ~/.fzf.bash ] && [ -r ~/.bashrcs/fzf.bash ] && source ~/.bashrcs/fzf.bash
