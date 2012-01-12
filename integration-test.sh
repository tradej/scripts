#!/bin/bash

if [ $# -lt 2 ]; then
    echo 'Too few parameters' 1>&2
    popd &> /dev/null
    exit 1
fi

rpmfile="$2"
name="$1"
tmpdir="/tmp/integration/$name"

rm -rf $tmpdir # TODO More sensitive approach desirable
mkdir -p $tmpdir
if [ $? -ne 0 ]; then exit; fi

pushd . &> /dev/null

cd $tmpdir
if [ $? -ne 0 ]; then 
    echo 'Folder does not exist' 1>&2
    popd &> /dev/null
    exit 1
fi

repoquery --whatrequires $name --enablerepo rawhide-source --archlist src 2> dependent.txt

for i in `cat dependent.txt`; do
    echo $i
done

popd &> /dev/null
