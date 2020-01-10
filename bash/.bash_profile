#!/bin/bash
# bashrc and bash_aliases sourced at bottom of file
# Set prompt
PS1="\[\e[0;32m\]\u@\h:\w>\[\e[m\] "

export PGDATA='/var/lib/postgresql/10/main'
case $OSTYPE in
  darwin*) export PGDATA='/usr/local/var/postgres' ;;
esac
export EDITOR=nvim
export TERM=xterm-256color
export CLICOLOR=1

# Hard-coded $(brew --prefix) for /usr/local
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

if [ -f /usr/local/opt/bash-git-prompt/share/gitprompt.sh ]; then
  __GIT_PROMPT_DIR=/usr/local/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_THEME=Single_line_Solarized
  source /usr/local/opt/bash-git-prompt/share/gitprompt.sh
fi
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_THEME=Single_line_Solarized
  source $HOME/.bash-git-prompt/gitprompt.sh
fi

[ -r ~/.bash_aliases ] && source ~/.bash_aliases
[ -r ~/.bashrc ] && source ~/.bashrc
[ -f ~/.fzf.bash ] && [ -f ~/.bash_fzf ] && source ~/.bash_fzf

#=== Package Managers START ===
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
#=== Package Managers END ===
