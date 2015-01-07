#!/usr/bin/bash

xrandr --output DP2-2 --off
xrandr --output DP2-3 --off
xrandr --output DP2-3 --pos 1366x0 --primary --mode 1920x1080
xrandr --output DP2-2 --pos 3286x0 --mode 1920x1080
xrandr --output eDP1 --pos 0x300

xfconf-query -c xfce4-panel -p /panels/panel-1/output-name -s DP2-3
