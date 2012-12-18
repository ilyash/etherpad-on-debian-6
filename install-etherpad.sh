#!/bin/bash

# By Ilya Sher, Coding-Knight LTD. http://coding-knight.com/
# Based on http://mclear.co.uk/2011/08/01/install-etherpad-lite-on-ubuntu/
# Input: Clean Debian 6 install (probably a VM), ready to be totally f*cked up
#        (apt-configuration-wise)
# Output: Running Etherpad Lite
# Testing: works-for-me
# Optimizations: none at all, some things are probably not necessary.

function cond_fail() {
	if [ $? -ne 0 ];then
		echo $2
		exit $1
	fi
}

cat >/etc/apt/sources.list <<END
deb http://mirror.isoc.org.il/pub/debian/ wheezy main non-free contrib
deb-src http://mirror.isoc.org.il/pub/debian/ wheezy main non-free contrib

deb http://security.debian.org/ wheezy/updates main contrib non-free
deb-src http://security.debian.org/ wheezy/updates main contrib non-free

deb http://mirror.isoc.org.il/pub/debian/ sid main

deb http://mirror.isoc.org.il/pub/debian/ experimental main
END

cond_fail 1 "Fail to update /etc/apt/sources.list"

cat >/etc/apt/preferences <<END
Package: *
Pin: release a=stable
Pin-Priority: 700

Package: *
Pin: release a=testing
Pin-Priority: 650

Package: *
Pin: release a=unstable
Pin-Priority: 600

Package: *
Pin: release a=lenny
Pin-Priority: 600
END

cond_fail 2 "Fail to update /etc/apt/preferences"

apt-get update
apt-get -y install build-essential python libssl-dev git-core git libsqlite3-dev gzip curl
apt-get -y install nodejs npm git vim bash-completion

cond_fail 3 "Fail to install nodejs and/or npm"

ln -s /usr/bin/nodejs /usr/bin/node

useradd -m ep
su - ep -c 'git clone git://github.com/ether/etherpad-lite'
su - ep -c 'etherpad-lite/bin/run.sh'
