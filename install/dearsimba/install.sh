#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/../p4d/default"

su - vagrant -c "p4 client -i << MUFASA
Client: $P4USER
Owner: $P4USER
Host: $(hostname)
Root: /home/vagrant/depot
Options: noallwrite noclobber nocompress unlocked nomodtime normdir
SubmitOptions: submitunchanged
LineEnd: local
View: //depot/... //$P4USER/...
MUFASA"

cp "${WD}"/rememberwhoyouare.c /home/vagrant/depot/
cp "${WD}"/Makefile /home/vagrant/depot/

su - vagrant -c 'p4 add /home/vagrant/depot/*'
su - vagrant -c 'p4 submit -d "dear simba"'
