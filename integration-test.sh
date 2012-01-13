#!/bin/bash

if [ $# -lt 2 ]; then
    echo 'Too few parameters' 1>&2
    popd &> /dev/null
    exit 1
fi

custom_rpm="$2"
name="$1"
tmpdir="/tmp/integration/$name"
logfile="$tmpdir/result.txt"

echo "Integration test for $name" 1>&2

rm -rf $tmpdir 2> /dev/null # TODO More sensitive approach desirable
mkdir -p $tmpdir
if [ $? -ne 0 ]; then exit; fi

pushd . &> /dev/null

cd $tmpdir
if [ $? -ne 0 ]; then 
    echo 'Folder does not exist' 1>&2
    popd &> /dev/null
    exit 1
fi

repoquery --whatrequires $name --enablerepo rawhide-source --archlist src 2> /dev/null | sed -e 's/-\([0-9]:\)\?[0-9.\-]*.fc..\.src//' > dependent.txt
echo 'Initializing Mock' 1>&2
mock -r fedora-rawhide-x86_64 init &> /dev/null &&
echo 'Installing package' 1>&2 &&
mock -r fedora-rawhide-x86_64 install $custom_rpm &> /dev/null

if [ $? -ne 0 ]; then 
    echo 'Mock error!' 1>&2
    popd &> /dev/null
    exit 1
fi


echo 'Building packages' 1>&2
echo '--------------------'
# Build each package
for i in `cat dependent.txt`; do
    echo -n "$i " | tee -a $logfile
    fedpkg clone $i &> /dev/null
    cd $i
    fedpkg sources &> /dev/null

    # Building
    srpm=`fedpkg srpm | sed -e 's/Wrote: //'`
    mock -r fedora-rawhide-x86_64 rebuild $srpm --no-clean &> /dev/null
    if [ $? -ne 0 ]; then
        echo failed | tee -a $logfile
        echo $i >> $tmpdir/failed.tmp
    else
        echo passed | tee -a $logfile
    fi
    
    # Copying results
    mkdir result
    cp /var/lib/mock/fedora-rawhide-x86_64/result/*.log -t ./result

    cd $tmpdir
done

echo '--------------------'

cd $tmpdir

# In case there were failed builds
file $tmpdir/failed.tmp &> /dev/null
if [ $? -eq 0 ]; then
    broken_logfile="$tmpdir/broken.log"
    failed_logfile="$tmpdir/failed.log"
    touch $failed_logfile
    
    echo 'Packages have failed to build!'
    echo 'Initializing Mock'
    mock -r fedora-rawhide-x86_64 init &> /dev/null
    echo 'Rebuilding failed packages'
    echo '--------------------'

    for i in `cat failed.tmp`; do
        echo -n "$i " | tee -a $failed_logfile
        cd $i

	    # Building
	    srpm=`fedpkg srpm | sed -e 's/Wrote: //'`
	    mock -r fedora-rawhide-x86_64 rebuild $srpm --no-clean &> /dev/null
	    if [ $? -ne 0 ]; then
	        echo ftbfs | tee -a $failed_logfile
	    else
	        echo broken | tee -a $failed_logfile
            echo $i >> $broken_logfile
	    fi
	    
	    # Copying results
	    mkdir result-rebuild -p &> /dev/null
	    cp /var/lib/mock/fedora-rawhide-x86_64/result/*.log -t ./result-rebuild
	
	    cd $tmpdir
    done
fi

echo '--------------------'

popd &> /dev/null
