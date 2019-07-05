#!/bin/sh

# Get out of town if something errors
set -e

HDMI_STATUS=$(</sys/class/drm/card0/card0-HDMI-A-1/status )  

if [ "$HDMI_STATUS" == 'connected' ]; then  
    /usr/bin/xrandr --output HDMI1 --mode 3440x1440
    /usr/bin/xrandr --output eDP1 --off
else  
    /usr/bin/xrandr --output HDMI1 --off
    /usr/bin/xrandr --output eDP1 --auto
fi
