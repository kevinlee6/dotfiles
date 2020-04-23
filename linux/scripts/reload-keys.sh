#!/bin/bash
set -eo pipefail

# Ideally used with udev

pid=$(pgrep xcape | xargs)

if [ ! -z "$pid" ]; then
  # Word splitting wanted; don't double quote
  kill -9 $pid
fi

/usr/bin/xmodmap /home/kevin/.Xmodmap
/usr/bin/xcape -e 'Mode_switch=Escape'
