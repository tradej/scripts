#!/bin/bash

pactl list sinks | grep -q Mute:.no && pactl set-sink-mute 1 1 || pactl set-sink-mute 1 0
