#! /bin/bash

filename="$(date +%y-%m).txt"
fullname="/home/tradej/documents/status-reports/$filename"

cat $fullname | xsel
