# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

. ~/scripts/vcs.sh

function acl {

    if [ $# -eq 0 ]; then
        name=`basename $PWD`
    else
        name=$1
    fi

    pkgdb-cli acl "$name"
}


function mkd {
    mkdir $1
    cd $1
}

function clip {
    cat $1 | xsel
}

# == Mock Build ==
# Initiates a mock build of the current directory
# Copies sources extracted from the spec files to
# the rpmbuild directory, makes a SRPM and rebuilds
# it for the specified architecture
function build() {
	dist='rawhide'
	package_name=`pwd | sed -e 's/.*\///'`
	
	if [ $# -ge 1 ]; then
		dist="$1"
	fi
	
	for i in `spectool $package_name.spec | sed -e 's/.*: //'`; do
		cp -v `basename $i` ~/rpmbuild/SOURCES/ -f
	done
		
	rpm_name=`rpmbuild -bs $package_name.spec | grep Wrote | sed -e 's/Wrote: //'`
	
	file mockbuild &> /dev/null
	if [ "$?" -eq 0 ]; then
		rm -rf mockbuild/*
	else
		mkdir mockbuild
	fi

	return_value=1
	if [ "$dist" = "local" ]; then
		time rpmbuild -ba $package_name.spec $2 $3 2>&1 | tee mockbuild/build.log
		cp ~/rpmbuild/RPMS/noarch/$package_name* mockbuild
    elif [ "$dist" = "srpm" ]; then
        cp $rpm_name mockbuild
        return_value=$?
	elif [ "$dist" = "source" ]; then
		time rpmbuild -bs $package_name.spec $2 $3
		cp ~/rpmbuild/SRPMS/$package_name* mockbuild
	else
		time mock -r fedora-$dist-x86_64 rebuild $rpm_name $2 $3
		return_value=$?
	
		cp /var/lib/mock/fedora-$dist-x86_64/result/$package_name* \
		   /var/lib/mock/fedora-$dist-x86_64/result/*.log mockbuild -v
	fi

    result='failed'
    if [ $return_value -eq 0 ]; then
        result='passed'
    fi

    notify-send "Build $package_name finished" "`date`\r$result"
	echo $result
	$( exit $return_value )
}

# == Clone package ==
function fclone() {

    if [ $# -eq 0 ]; then
        echo clone-package: Clone a Fedora package and extract its contents
        echo 'Usage: clone-package <filename> <arguments>'
        return
    fi

    fedpkg clone $1
    cd $1
    fedpkg prep
}

# == Extract ==
# Attempts to extract a file based on extension
function x() {

    if [ $# -eq 0 ]; then
        echo extract: Extract file based on extension
        echo 'Usage: extract <filename> <arguments>'
        return
    fi

    # Determining extract/list action
    options='extract'
    filename=''
    for i in $*; do
        if [ "$i" = '-l' ]; then options='list';
        elif [ $( file $i &> /dev/null; echo $? ) -eq '0' ]; then filename=$i;
        else echo Wrong option; return
        fi
    done

    if [ "$filename" = '' ]; then
        echo You must specify filename!
        return
    fi

    extension=$( echo $filename | awk -F . '{print $NF}' )
    args=''

    if [ "$extension" = 'tar' -o "$extension" = 'gz' -o "$extension" = 'xz' -o "$extension" = 'tgz' ]; then
        if [ "$options" = 'extract' ]; then args='-xa'
        elif [ "$options" = 'list' ]; then args='-at'; fi;

        tar -f $filename $args

    elif [ "$extension" = 'jar' ]; then
        if [ "$options" = 'extract' ]; then args='-xf'
        elif [ "$options" = 'list' ]; then args='-tf'; fi;

        jar $args $filename

    elif [ "$extension" = 'zip' ]; then
        if [ "$options" = 'extract' ]; then args=''
        elif [ "$options" = 'list' ]; then args='-l'; fi

        unzip $args $filename

    elif [ "$extension" = 'rpm' ]; then
        if [ "$options" = 'extract' ]; then
            rpm2cpio "$filename" | cpio -idv
        elif [ "$options" = 'list' ]; then
            rpm -qlp $filename
        fi

    fi

}

function gcd {
    cd "$1"
    git pull --ff-only
}


# User specific aliases and functions
alias ..='cd ..'
alias cls='printf "\033c"'
alias setend='xmodmap -e "keycode 118 = End NoSymbol End"'
alias setinsert='xmodmap -e "keycode 118 = Insert NoSymbol Insert"'
alias la='ls -lA'
alias less='/usr/share/vim/vim*/macros/less.sh'
alias lr='ls -R'
alias py='python'
alias py3='python3'
alias p3pip='python3-pip'
alias search='grep -Hnis'
alias rsearch='grep -RHnis'

# Fedora
alias query-rawhide='repoquery --enablerepo=rawhide'
alias query-src-rawhide='repoquery --enablerepo=rawhide --archlist=src'
alias spec='vim *.spec'
alias prep='fedpkg prep'

# RH
alias clip-status='source ~/scripts/clip-status-report.sh'
alias status='source ~/scripts/new-status-report.sh'

# Git
alias gamend='git commit -a --amend -m"`git log -1 --pretty=%B`"'
alias gc='git checkout'
alias gcl='fedpkg clog; git commit -m"`cat clog`"'
alias gco='git commit -m'
alias gdiff='git diff'
alias gdifft='git difftool -d'
alias ginit='git init && git add * && git commit -a -m "Initial commit"'
alias gpff='git pull --ff-only'
alias gpr='git pull --rebase'
alias gst='git status'
alias qgit='qgit --all 2> /dev/null'
