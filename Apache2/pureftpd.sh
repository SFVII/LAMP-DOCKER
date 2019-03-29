#!/bin/bash

mkdir /tmp/pure-ftpd/

cd /tmp/pure-ftpd
apt-get source pure-ftpd
cd pure-ftpd-*

sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
dpkg-buildpackage -b -uc -d

dpkg -i /tmp/pure-ftpd/pure-ftpd-common*.deb
apt-get -y install openbsd-inetd
dpkg -i /tmp/pure-ftpd/pure-ftpd_*.deb

apt-mark hold pure-ftpd pure-ftpd-common
