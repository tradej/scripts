#!/usr/bin/bash

EXECDIR=~

dirlist=$(find $EXECDIR -type d -name .git -exec dirname '{}' ';')

dirs -c

for entry in $dirlist; do
    pushd $entry &> /dev/null
    list="$(git log --author='Tomas Radej' --since="30 days ago" --pretty=format:'\n%s')"
    if [ "$list" != "" ]; then
        echo
        tput setaf 4
        echo $entry
        tput setaf 2
        echo ===============================
        tput sgr0
        echo -e $list
    fi
    popd &> /dev/null
done
