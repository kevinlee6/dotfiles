#!/bin/bash

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

if [ -d "$HOME/.cargo" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

export NVM_DIR="$([ -z ${XDG_CONFIG_HOME-} ] && printf %s ${HOME}/.nvm || printf %s ${XDG_CONFIG_HOME}/nvm)"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# Package Managers END =========================================================

[ -r ~/.bashrc ] && source ~/.bashrc
[ -r ~/.bashrcs/kevin.bash ] && source ~/.bashrcs/kevin.bash
