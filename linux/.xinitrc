#!/bin/bash
# Made executable so it can be sourced in i3 config.
# Ideally it would be used with startx, but I'm missing a lot of the "default"
# xinitrc files listed in arch wiki.

# Need to run this to set default vars.
# . /etc/X11/Xsession.d/20dbus_xdg-runtime

# From arch wiki:
# if [ -d /etc/X11/xinit/xinitrc.d ] ; then
#   for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
#     [ -x "$f" ] && . "$f"
#     done
#   unset f
# fi

# SSH
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
ssh-add

# Lock
# notes:
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

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Keep as last line.
# exec i3
