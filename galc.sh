#!/bin/bash

ps -e | grep galculator

if [ $? -eq 0 ]; then
    kill `ps -e | grep galculator | sed 's/ [^0-9].*$//'`
else
    galculator &
fi
