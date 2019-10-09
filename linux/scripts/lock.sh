#!/bin/sh
set -e

# Locks screen when suspended
# Intended to be called by /etc/systemd/system/lock.service
# Needs i3lock and a wallpaper.png

xset s off dpms 0 10 0
/usr/bin/i3lock -e -n --ignore-empty-password -c 002b36 -i /home/kevin/Pictures/wallpaper.png
xset s off -dpms
