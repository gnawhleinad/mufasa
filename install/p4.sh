#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/p4d/default"

curl -sSO http://filehost.perforce.com/perforce/r14.2/bin.linux26x86_64/p4
mv p4 /usr/local/bin
chmod 755 /usr/local/bin/p4

cat > /home/vagrant/.p4config << MUFASA
P4CLIENT=mufasa
P4PORT=$P4PORT
P4USER=mufasa
P4PASSWD=mufasa
P4EDITOR=vim
MUFASA
chown vagrant:vagrant /home/vagrant/.p4config
echo "export P4CONFIG=~/.p4config" >> /home/vagrant/.profile

mkdir /home/vagrant/depot
chown vagrant:vagrant /home/vagrant/depot
