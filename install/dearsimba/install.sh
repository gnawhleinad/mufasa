#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/../p4d/default"

cp "${WD}"/rememberwhoyouare.c /home/vagrant/depot/
cp "${WD}"/Makefile /home/vagrant/depot/

su - vagrant -c 'p4 add /home/vagrant/depot/*'
su - vagrant -c 'p4 submit -d "dear simba"'
