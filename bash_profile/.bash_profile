# Set prompt
PS1="\[\e[0;33m\]\u@\h:\w>\[\e[m\] "

export PGDATA="/usr/local/var/postgres"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export EDITOR=vim
export TERM=screen-256color

# Hard-coded $(brew --prefix) for /usr/local
if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion 
fi

if [ -f /usr/local/opt/bash-git-prompt/share/gitprompt.sh ]; then
  __GIT_PROMPT_DIR=/usr/local/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_THEME=Solarized
  source /usr/local/opt/bash-git-prompt/share/gitprompt.sh
fi

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PROMPT_THEME=Solarized
  source $HOME/.bash-git-prompt/gitprompt.sh
fi

### Package Managers Start ###
if [ -d ~/.rbenv ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh --no-use"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
### Package Managers End ###

alias tmux='tmux -2 '
alias ls='ls -FHG'

#COC LSP
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -e ~/.bashrc ]; then
  source ~/.bashrc
fi