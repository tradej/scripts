#! /usr/bin/bash

# Copyright 2014 Tomas Radej, Red Hat Inc.

function parse_git_dirty {
    git status 2> /dev/null | tail -1 | grep -q 'working directory clean' || echo "*"
}
function parse_git_branch {
    git rev-parse --abbrev-ref HEAD 2> /dev/null
}
function parse_hg_branch {
    hg branch 2> /dev/null
}

function vcs_branches {
    git=$(parse_git_branch)
    hg=$(parse_hg_branch)

    if [ "$git" != '' ]; then
        result=${git}$(parse_git_dirty)
    elif [ "$hg" != '' ]; then
        result=$hg
    fi

    if [ "$result" != '' ]; then
        echo ' '$result
    fi
}

export PS1='[\u@\h \[\033[1;34m\]\W\[\033[0m\]\[\033[1;32m\]$(vcs_branches)\[\033[0m\]]$ '

