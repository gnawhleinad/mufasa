#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/default"

mkdir $P4ROOT

curl -sSO http://filehost.perforce.com/perforce/r14.2/bin.linux26x86_64/p4d
mv p4d /usr/local/bin
chmod 755 /usr/local/bin/p4d

mkdir -p $(dirname $P4LOG)
mkdir -p $(dirname $P4JOURNAL)

cp "${WD}/init" /etc/init.d/p4d
chmod 755 /etc/init.d/p4d

cp "${WD}/default" /etc/default/p4d
chmod 755 /etc/default/p4d

update-rc.d p4d defaults
/etc/init.d/p4d start

curl -sSO http://filehost.perforce.com/perforce/r14.2/bin.linux26x86_64/p4
mv p4 /usr/local/bin
chmod 755 /usr/local/bin/p4

P4PORT=$P4PORT p4 user -i -f << MUFASA
User: $P4USER
Password: $P4PASSWD
Email: mufasa@priderock
FullName: mufasa, great king of the past 
MUFASA

P4PORT=$P4PORT p4 protect -i << SIMBA
Protections:
	write user * * //...
	super user $P4USER * //...
SIMBA
