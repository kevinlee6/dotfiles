# Contains alias and functions
alias be='bundle exec ' # Less important in Rails 5+
alias less='less -S' # Don't text wrap
alias rg='rg --smart-case -n ' # Smart case sensitivity; show line number
alias sourcebash='source ~/.bash_profile'

# ls depending on OS
alias ls='ls --color=always'
case $OSTYPE in
  darwin*) alias ls='ls -FGH' ;;
esac

#=== Wifi START ===
# Does not seem to work well if network name is more than one word
wifi() {
  if [[ -z $1 ]]; then
    nmcli dev wifi
  elif [[ -z $2 ]]; then
    nmcli device wifi connect "$@"
  else
    nmcli device wifi connect "$1" password "$2"
  fi
}
#=== Wifi END ===

#=== Git START ===
# gco located in ~/.bash_fzf

glog() {
  if [[ -z $1 ]]; then
    git log --patch -- . ":(exclude)*.min.*"
  else
    git log --patch -- . ":(exclude)$1"
  fi
}

gdiff() {
  if [[ -z $1 ]]; then
    git diff -- . ":(exclude)*.min.*"
  else
    git diff -- . ":(exclude)$1"
  fi
}

alias groot='cd "$(git rev-parse --show-toplevel)"'
#=== Git END ===

# Temporary until better solution found
alias rkeys='~/scripts/reload-keys.sh'
