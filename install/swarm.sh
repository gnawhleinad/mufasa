#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/p4d/default"

wget -q http://package.perforce.com/perforce.pubkey -O - | sudo apt-key add -
cat > /etc/apt/sources.list.d/perforce.sources.list << MUFASA
deb http://package.perforce.com/apt/ubuntu precise release 
MUFASA

apt-get update
apt-get install -qq perforce-swarm

/opt/perforce/swarm/sbin/configure-swarm.sh -p $P4PORT -u swarm -w mufasa -c -U $P4USER -W $P4PASSWD
