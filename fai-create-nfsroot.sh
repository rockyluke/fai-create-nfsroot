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

function makeroot ()
{

    RELEASE=${1}
    CONF=${PWD}/etc/${RELEASE}

    # clean nfsroot
    if [ -d ${LIVE} ]
    then
	umount -f -l ${LIVE}/var/lib/dpkg > /dev/null 2>&1
	umount -f -l ${LIVE}/var/cache > /dev/null 2>&1
	rm -rf ${LIVE}
    fi

    # make nfsroot
    if [ -d ${CONF} ]
    then
	if [ ${RELEASE} = 'lenny' ] || [ ${RELEASE} = 'squeeze' ]
	then
	    # live
	    COMMAND="fai-make-nfsroot"
	elif [ ${RELEASE} = 'wheezy' ]
	then
	    # force live
	    COMMAND="fai-make-nfsroot -l"
	else
	    # aufs
	    COMMAND="fai-make-nfsroot"
	fi
	docker run --privileged \
	       --volume ${NFSROOT}:${NFSROOT}:rw \
	       --volume ${CONF}:/etc/fai:ro \
	       rockyluke/fai:${RELEASE} \
	       ${COMMAND}
	if [ ${?} -ne 0 ]
	then
	    echo "debootstrap error in docker..."
	    exit 1
	fi
    fi

    # convert base.tar.xz to base.tar.gz
    if [ -f ${LIVE}/var/tmp/base.tar.xz ]
    then
	cd ${LIVE}/var/tmp
	xz -d base.tar.xz
	gzip base.tar
	mv base.tar.gz base.tgz
    fi

} # makeroot

if [ ! -x "$(command -v docker)" ]
then
    echo "Please install docker (see README.md)"
    exit 1
fi

case ${1} in
    lenny)
	echo '-- Debian 5.0 (lenny)'
	NFSROOT='/srv/fai/nfsroot/debian/lenny'
	TFTP='/srv/tftp/debian/'
	LIVE="${NFSROOT}/live/filesystem.dir/"
	makeroot lenny
	echo 'DEBIAN LENNY' > ${LIVE}/.FAI
	;;
    squeeze)
	echo '-- Debian 6.0 (squeeze)'
	NFSROOT='/srv/fai/nfsroot/debian/squeeze'
	TFTP='/srv/tftp/debian/'
	LIVE="${NFSROOT}/live/filesystem.dir/"
	makeroot squeeze
	echo 'DEBIAN SQUEEZE' > ${LIVE}/.FAI
	;;
    wheezy)
	echo '-- Debian 7.0 (wheezy)'
	NFSROOT='/srv/fai/nfsroot/debian/wheezy'
	TFTP='/srv/tftp/debian/'
	LIVE="${NFSROOT}/live/filesystem.dir/"
	makeroot wheezy
	echo 'DEBIAN WHEEZY' > ${LIVE}/.FAI
	;;
    jessie)
	echo '-- Debian 8.0 (jessie)'
	NFSROOT='/srv/fai/nfsroot/debian/jessie'
	TFTP='/srv/tftp/debian/'
	LIVE=${NFSROOT}
	makeroot jessie
	echo 'DEBIAN JESSIE' > ${LIVE}/.FAI
	;;
    stretch)
	echo '-- Debian 9.0 (stretch)'
	NFSROOT='/srv/fai/nfsroot/debian/stretch'
	TFTP='/srv/tftp/debian/'
	LIVE=${NFSROOT}
	makeroot stretch
	echo 'DEBIAN STRETCH' > ${LIVE}/.FAI
	;;
    precise)
	echo '-- Ubuntu 12.04 LTS (precise)'
	NFSROOT='/srv/fai/nfsroot/ubuntu/precise'
	TFTP='/srv/tftp/ubuntu/'
	LIVE=${NFSROOT}
	makeroot precise
	echo 'UBUNTU PRECISE' > ${LIVE}/.FAI
	;;
    trusty)
	echo '-- Ubuntu 14.04 LTS (trusty)'
	NFSROOT='/srv/fai/nfsroot/ubuntu/trusty'
	TFTP='/srv/tftp/ubuntu/'
	LIVE=${NFSROOT}
	makeroot trusty
	echo 'UBUNTU TRUSTY' > ${LIVE}/.FAI
	;;
    yakkety)
	echo '-- Ubuntu 16.04 LTS (yakkety)'
	NFSROOT='/srv/fai/nfsroot/ubuntu/yakkety'
	TFTP='/srv/tftp/ubuntu/'
	LIVE=${NFSROOT}
	makeroot yakkety
	echo 'UBUNTU YAKKETY' > ${LIFE}/.FAI
	;;
    *)
	echo 'You need to choose one Debian or Ubuntu release'
	;;
esac
# EOF
