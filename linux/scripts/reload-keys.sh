#!/bin/sh
set -e
# Ideally used with udev

pid=$(pgrep xcape | xargs)

if [ -n "$pid" ]; then
  # Word splitting wanted; don't double quote
  kill -9 $pid
fi

/usr/bin/xmodmap /home/kevin/.Xmodmap
/usr/bin/xcape -e 'Mode_switch=Escape'
