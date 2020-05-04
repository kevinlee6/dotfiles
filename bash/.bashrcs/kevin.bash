#!/bin/bash
# This rc is designed for optional stuff that I personally use. It's in its own
# file so it is less intrusive and can be easily sourced from a primary
# .bash_profile/.bashrc/etc.

# Set prompt
PS1="\[\e[0;32m\]\u@\h:\w>\[\e[m\] "
export EDITOR=nvim
export CLICOLOR=1

# Tmux bash runs non login shell
if [ -n $(which fzf) ] && [ -n $(which tmux) ] && [ -n "$TMUX_PANE" ]; then
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
if [ -n "$(which brew)" ]; then
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
export XSECURELOCK_BLANK_DPMS_STATE=suspend

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_THEME=Single_line_Solarized
  source $HOME/.bash-git-prompt/gitprompt.sh
fi
# Linux END ====================================================================

# Package Managers START =======================================================
if [ -d "$HOME/.rbenv" ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

export NVM_DIR="$([ -z ${XDG_CONFIG_HOME-} ] && printf %s ${HOME}/.nvm || printf %s ${XDG_CONFIG_HOME}/nvm)"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# Package Managers END =========================================================

[ -r ~/.bashrcs/aliases.bash ] && source ~/.bashrcs/aliases.bash
[ -r ~/.fzf.bash ] && [ -r ~/.bashrcs/fzf.bash ] && source ~/.bashrcs/fzf.bash
