#!/bin/bash

# Set prompt
PS1="\[\e[0;32m\]\u@\h:\w>\[\e[m\] "

export PGDATA='/var/lib/postgresql/10/main'
case $OSTYPE in
  darwin*) export PGDATA='/usr/local/var/postgres' ;;
esac
export EDITOR=nvim
export TERM=xterm-256color
export CLICOLOR=1
export XSECURELOCK_BLANK_DPMS_STATE=suspend

[ -r ~/.bash_aliases ] && source ~/.bash_aliases
[ -r ~/.bashrc ] && source ~/.bashrc
[ -r ~/.bashrc_kevin ] && source ~/.bashrc_kevin

# Package Managers START =======================================================
if [ -d ~/.rbenv ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi
if [ -d ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

export NVM_DIR="$([ -z ${XDG_CONFIG_HOME-} ] && printf %s ${HOME}/.nvm || printf %s ${XDG_CONFIG_HOME}/nvm)"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# Package Managers END =========================================================
