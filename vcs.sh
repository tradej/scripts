#! /usr/bin/bash

# Copyright (C) 2014 Tomas Radej, <tradej @ redhat.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

function parse_git_dirty {
    result=''
    git ls-files --others --exclude-standard 2> /dev/null | grep -q . && result='+'
    git diff --shortstat | grep -q . && result='*'
    echo "$result"
}
function parse_git_branch {
    git rev-parse --abbrev-ref HEAD 2> /dev/null
}
function parse_hg_branch {
    if $(which hg 2> /dev/null); then
        hg branch 2> /dev/null
    fi
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

function promptretval {
    value=$?
    if [ $value -ne 0 ]; then
        echo "$value "
    fi
}

export PS1='[\u@\h \[\033[1;31m\]$(promptretval)\[\033[0m\]\[\033[1;34m\]\W\[\033[0m\]\[\033[1;32m\]$(vcs_branches)\[\033[0m\]]$ '

