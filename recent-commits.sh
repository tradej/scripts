#!/usr/bin/bash

if [ $# -lt 2 ]; then
    DAYS="7"
else
    DAYS="$1"
fi
DATE="$(date -d $DAYS\ days\ ago)"

for dir in $(find ~ -name .git); do
    pushd $(dirname $dir) &> /dev/null
    log=$(git log --pretty=\\n%s --abbrev-commit --all --author=Tomas\ Radej --since="$DATE" 2> /dev/null)

    if [ "$log" != "" ]; then
        name=$(basename $PWD)
        echo "$name ($PWD)"
        echo $name | sed -e 's/./=/g'
        echo -e $log
        echo
    fi
    popd &> /dev/null
done

