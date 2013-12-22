#!/bin/bash

ps -e | grep redshift

if [ $? -eq 0 ]; then
    kill `ps -e | grep redshift | sed 's/ [^0-9].*$//'`
else
    redshift -t 6500K:4500K & echo ''
fi
