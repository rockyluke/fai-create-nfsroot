#!/usr/bin/env bash

# Copyright (c) 2017, rockyluke
#
# Permission  to use,  copy, modify,  and/or  distribute this  software for  any
# purpose  with  or without  fee  is hereby  granted,  provided  that the  above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS"  AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO  THIS SOFTWARE INCLUDING  ALL IMPLIED WARRANTIES  OF MERCHANTABILITY
# AND FITNESS.  IN NO EVENT SHALL  THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR  CONSEQUENTIAL DAMAGES OR  ANY DAMAGES WHATSOEVER  RESULTING FROM
# LOSS OF USE, DATA OR PROFITS,  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER  TORTIOUS ACTION,  ARISING  OUT OF  OR  IN CONNECTION  WITH  THE USE  OR
# PERFORMANCE OF THIS SOFTWARE.

function makeroot()
{
    # variables
    release=${1}
    conf=${PWD}/etc/${release}

    if [ "$(id -u)" -ne 0 ]
    then
        sudo='sudo'
    fi

    # clean nfsroot
    if [ -d "${nfslive}" ]
    then
	${sudo} umount -f -l "${nfslive}/var/lib/dpkg" > /dev/null 2>&1
	${sudo} umount -f -l "${nfslive}/var/cache" > /dev/null 2>&1
	${sudo} rm -rf "${nfslive}"
    fi

    # make nfsroot
    if [ -d "${conf}" ]
    then
	docker run \
	       --privileged \
	       --volume "${nfsroot}:${nfsroot}:rw" \
	       --volume "${conf}:/etc/fai:ro" \
	       "rockyluke/fai:${release}" \
	       "${run}"
	if [ ${?} -ne 0 ]
	then
	    echo "debootstrap error in docker..."
	    exit 1
	fi
    fi

    # convert base.tar.xz to base.tar.gz
    if [ -f "${nfslive}/var/tmp/base.tar.xz" ]
    then
	cd "${nfslive}/var/tmp" || exit 1
	${sudo} xz -d base.tar.xz
	${sudo} gzip base.tar
	${sudo} mv base.tar.gz base.tgz
    fi
}

if [ ! -x "$(command -v sudo)" ]
then
    echo "Please install sudo (see README.md)"
    exit 1
fi

if [ ! -x "$(command -v docker)" ]
then
    echo "Please install docker (see README.md)."
    exit 1
fi

case ${1} in
    lenny)
	echo '-- Debian 5.0 (lenny)'
	nfsroot='/srv/fai/nfsroot/debian/lenny'
	nfslive="${nfsroot}/live/filesystem.dir"
	run='fai-make-nfsroot'
	makeroot lenny
	echo 'DEBIAN LENNY' > "${nfslive}/.FAI"
	;;
    squeeze)
	echo '-- Debian 6.0 (squeeze)'
	nfsroot='/srv/fai/nfsroot/debian/squeeze'
	nfslive="${nfsroot}/live/filesystem.dir"
	run='fai-make-nfsroot'
	makeroot squeeze
	echo 'DEBIAN SQUEEZE' > "${nfslive}/.FAI"
	;;
    wheezy)
	echo '-- Debian 7.0 (wheezy)'
	nfsroot='/srv/fai/nfsroot/debian/wheezy'
	nfslive="${nfsroot}/live/filesystem.dir"
	run='fai-make-nfsroot -l'
	makeroot wheezy
	echo 'DEBIAN WHEEZY' > "${nfslive}/.FAI"
	;;
    jessie)
	echo '-- Debian 8.0 (jessie)'
	nfsroot='/srv/fai/nfsroot/debian/jessie'
	nfslive=${nfsroot}
	run='fai-make-nfsroot'
	makeroot jessie
	echo 'DEBIAN JESSIE' > "${nfslive}/.FAI"
	;;
    stretch)
	echo '-- Debian 9.0 (stretch)'
	nfsroot='/srv/fai/nfsroot/debian/stretch'
	nfslive=${nfsroot}
	run='fai-make-nfsroot'
	makeroot stretch
	echo 'DEBIAN STRETCH' > "${nfslive}/.FAI"
	;;
    precise)
	echo '-- Ubuntu 12.04 LTS (precise)'
	nfsroot='/srv/fai/nfsroot/ubuntu/precise'
	nfslive=${nfsroot}
	run='fai-make-nfsroot'
	makeroot precise
	echo 'UBUNTU PRECISE' > "${nfslive}/.FAI"
	;;
    trusty)
	echo '-- Ubuntu 14.04 LTS (trusty)'
	nfsroot='/srv/fai/nfsroot/ubuntu/trusty'
	nfslive=${nfsroot}
	run='fai-make-nfsroot'
	makeroot trusty
	echo 'UBUNTU TRUSTY' > "${nfslive}/.FAI"
	;;
    yakkety)
	echo '-- Ubuntu 16.04 LTS (yakkety)'
	nfsroot='/srv/fai/nfsroot/ubuntu/yakkety'
	nfslive=${nfsroot}
	run='fai-make-nfsroot'
	makeroot yakkety
	echo 'UBUNTU YAKKETY' > "${nfslive}/.FAI"
	;;
    *)
	echo 'You need to choose one Debian or Ubuntu release'
	;;
esac
# EOF
