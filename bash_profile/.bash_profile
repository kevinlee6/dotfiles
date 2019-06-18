# Set prompt
PS1="\[\e[0;32m\]\u@\h:\w>\[\e[m\] "

export PGDATA="/usr/local/var/postgres"
export EDITOR=nvim
export TERM=xterm-256color
export CLICOLOR=1

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

alias ls='ls --color=always'
[[ $OSTYPE == "darwin"* ]] && alias ls='ls -FHG'

# COC LSP
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if [ -f ~/.fzf.bash ]; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

  # Provide a preview window when fuzzy searching files
  # Bat used to provide colorized output (requires external install); otherwise cat
  bat='bat {} --style=numbers --color=always'
  preview="'$bat || cat {} | head -100'"
  preview_ls="'ls --color=always {}'"
  [[ $OSTYPE == "darwin"* ]] && preview_ls="'ls -FHG {}'"

  # Takes a preview argument and "returns" a string
  gen_fzf_opts() {
    echo "--height 40% --reverse --preview $1 --preview-window right:60%"
  }

  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_CTRL_T_OPTS=$(gen_fzf_opts "$preview")
  export FZF_ALT_C_COMMAND='fd -t d --hidden --follow --exclude .git'
  export FZF_ALT_C_OPTS=$(gen_fzf_opts "$preview_ls")

  # Directly open file from fzf w/ Ctrl-p
  fzf_then_open_in_editor() {
    # How to avoid eval without hard coding? If anything, FZF source code also uses eval.
    local file=$(eval fzf $(gen_fzf_opts "$preview"))
    [ -f "$file" ] && ${EDITOR:-vim} "$file"
  }
  bind -x '"\C-p": fzf_then_open_in_editor'

  # Open a file starting from home directory, mapped to C-g
  fzf_global_open() {
    (cd ~; fzf_then_open_in_editor)
  }
  bind -x '"\C-g": fzf_global_open'

  # Bind global cd to Alt-g
  # Method called in .inputrc bc need to refresh readline
  fzf_global_cd() {
    local dir=$(cd ~; echo $(eval "$FZF_ALT_C_COMMAND" | eval fzf "$FZF_ALT_C_OPTS"))
    [ -n "$dir" ] && [ -d "$HOME/$dir" ] && cd "$HOME/$dir"
  }

  # Fzf for git branches w/ gco alias
  fbr() {
    local branches branch
    branches=$(git --no-pager branch -vv) &&
      branch=$(echo "$branches" | fzf +m) &&
      git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
  }
  alias gco=fbr

  source ~/.fzf.bash
fi

if [ -e ~/.bashrc ]; then
  source ~/.bashrc
fi
