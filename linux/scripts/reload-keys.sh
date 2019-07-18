#!/bin/sh
set -e
# Ideally used with udev

pid=$(ps -eo "cmd,pid" | grep xcape | grep -v grep | grep -oP '\d*' | xargs)

if [ ! -z "$pid" ]; then
  kill -9 $pid
fi

/usr/bin/xmodmap /home/kevin/.Xmodmap
/usr/bin/xcape -e 'Mode_switch=Escape'
