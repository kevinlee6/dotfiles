#!/bin/sh
# Don't set pipefail until there is more elegant pid detection.
set -e

# Ideally used with udev

pid=$(pgrep xcape | xargs)

if [ ! -z "$pid" ]; then
  # Word splitting wanted; don't double quote
  kill -9 $pid
fi

[ -x "$(command -v xmodmap)" ] && xmodmap ~/.Xmodmap
[ -x "$(command -v xcape)" ] && xcape -e 'Mode_switch=Escape'
