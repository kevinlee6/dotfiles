#!/bin/sh
set -e

# Locks screen when suspended
# Intended to be called by /etc/systemd/system/lock-and-sleep.service

xset s activate
