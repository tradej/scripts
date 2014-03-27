#!/bin/bash

switch=''
if [ `xfconf-query --channel=xfwm4 --property=/general/use_compositing` == "true" ]; then
    switch="false"
else
    switch="true"
fi

xfconf-query --channel=xfwm4 --property=/general/use_compositing --set=$switch
