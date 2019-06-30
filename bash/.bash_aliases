# Contains alias and functions
alias rg='rg --smart-case '

# ls depending on OS
alias ls='ls --color=always'
[[ $OSTYPE == "darwin"* ]] && alias ls='ls -FHG'

#=== Wifi START ===
# Does not seem to work well if network name is more than one word
wifi() {
  if [[ -z $1 ]]; then
    eval 'nmcli dev wifi'
  elif [[ -z $2 ]]; then
    eval "nmcli device wifi connect '$@'"
  else
    eval "nmcli device wifi connect '$1' password '$2'"
  fi
}
#=== Wifi END ===

#=== Git START ===
# Shows detailed log, with optional exclude
glog() {
  if [[ -z $1 ]]; then
    eval 'git log -p'
  else
    eval "git log --patch -- . \":(exclude)$1\""
  fi
}

gdiff() {
  if [[ -z $1 ]]; then
    eval 'git diff'
  else
    eval "git diff -- . \":(exclude)$1\""
  fi
}
#=== Git END ===
