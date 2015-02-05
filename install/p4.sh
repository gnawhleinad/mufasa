#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/p4d/default"

if [ ! -f /usr/local/bin/p4 ]
then
	curl -sSO http://filehost.perforce.com/perforce/r14.2/bin.linux26x86_64/p4
	mv p4 /usr/local/bin
	chmod 755 /usr/local/bin/p4
fi

cat > /home/vagrant/.p4config << MUFASA
P4CLIENT=$(hostname)
P4PORT=$P4PORT
P4USER=$P4USER
P4PASSWD=$P4PASSWD
P4EDITOR=vim
MUFASA
chown vagrant:vagrant /home/vagrant/.p4config
echo "export P4CONFIG=~/.p4config" >> /home/vagrant/.profile

mkdir /home/vagrant/depot
chown vagrant:vagrant /home/vagrant/depot

P4PORT=$P4PORT p4 client -i << MUFASA
Client: $(hostname)
Owner: $P4USER
Host: $(hostname)
Root: /home/vagrant/depot
Options: noallwrite noclobber nocompress unlocked nomodtime normdir
SubmitOptions: submitunchanged
LineEnd: local
View: //depot/... //$(hostname)/...
MUFASA
