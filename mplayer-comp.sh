#!/bin/bash

source /home/tomas/scripts/compositing-disable.sh

gnome-mplayer "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"

source /home/tomas/scripts/compositing-enable.sh
