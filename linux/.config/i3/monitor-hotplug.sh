#!/bin/sh

# Get out of town if something errors
set -e

HDMI_STATUS=$(</sys/class/drm/card0/card0-HDMI-A-1/status )  

if [ "connected" == "$HDMI_STATUS" ]; then  
    /usr/bin/xrandr --output HDMI1 --display 3440x1440 --above eDP1 --auto
else  
    /usr/bin/xrandr --output HDMI1 --off
    exit
fi
