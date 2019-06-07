# Set prompt
PS1="\[\e[0;32m\]\u@\h:\w>\[\e[m\] "

export PGDATA="/usr/local/var/postgres"
export EDITOR=nvim
export TERM=xterm-256color

# Detect for gruvbox
if [ -d "$HOME/.vim/bundle/gruvbox" ]; then
  source "$HOME/.vim/bundle/gruvbox/gruvbox_256palette.sh"
fi

# Hard-coded $(brew --prefix) for /usr/local
if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion 
fi

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

### Package Managers Start ###
if [ -d ~/.rbenv ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh --no-use"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
### Package Managers End ###

alias ls='ls -FHG'

#COC LSP
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if [ -f ~/.fzf.bash ]; then
  # export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow 2> /dev/null'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd -t d --hidden --follow --exclude .git'

  fzf_then_open_in_editor() {
    local file=$(fzf)
    # Open the file if it exists
    if [ -n "$file" ]; then
      # Use the default editor if it's defined, otherwise Vim
      ${EDITOR:-vim} "$file"
    fi
  }

  bind -x '"\C-e": fzf_then_open_in_editor'

  source ~/.fzf.bash
fi

if [ -e ~/.bashrc ]; then
  source ~/.bashrc
fi
