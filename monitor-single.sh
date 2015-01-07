#!/usr/bin/bash

xrandr --output eDP1 --primary

xfconf-query -c xfce4-panel -p /panels/panel-1/output-name -s eDP1
