#!/usr/bin/bash

DEPS="$(repoquery --whatrequires pykickstart --recursive --resolve --qf '%{base_package_name}' | sort -u)"

pushd ~/development/fedora &> /dev/null
for dep in $DEPS; do
    fedpkg clone $dep &> /dev/null
    pushd $dep &> /dev/null
    fedpkg prep &> /dev/null

    lib=0; exe=0
    grep -Riq --include '*.py' 'import.*pykickstart\|pykickstart.*import'
    if [ $? -eq 0 ]; then lib=1; fi
    grep -Riq 'ks\(validator\|flatten\|shell\|verdiff\)'
    if [ $? -eq 0 ]; then exe=1; fi

    if [ $lib -eq 1 ]; then
        result='library'
        if [ $exe -eq 1 ]; then
            result='both'
        fi
        echo "$dep requires pykickstart as $result"
    elif [ $exe -eq 1 ]; then
        echo "$dep requires pykickstart as executable"
    fi
    popd &> /dev/null
done
popd &> /dev/null

