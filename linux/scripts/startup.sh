#!/bin/bash

# Ideally it should be in xinitrc, but ran into problems trying to do so.
# Plus these scripts can be used w/ other display managers (e.g. GDM) too.

# NOTES:
# - Make sure OS settings doesn't conflict w/ this via lock screen.
# - (xfce4) powermanager can also effect locktime.
xset s 120
if [ -z "$(ps aux | grep 'xsecurelock' | grep -v grep)" ]; then
  env XSECURELOCK_BLANK_DPMS_STATE=off xss-lock -n /usr/local/libexec/xsecurelock/dimmer -l -- xsecurelock &
fi

# Keyboard
# xmodmap / xcape related
[[ -x ~/scripts/reload-keys.sh ]] && sh ~/scripts/reload-keys.sh
[[ -x ~/scripts/monitor.sh ]] && sh ~/scripts/monitor.sh

# Xsession takes care of this.
# [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Remember to deactivate ssh-agent in Xsession.options
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
# ssh-add
