#!/bin/sh
export DISPLAY=:1
export XAUTHORITY=/run/user/1000/gdm/Xauthority

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
