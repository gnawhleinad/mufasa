#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/p4d/default"

wget -q http://package.perforce.com/perforce.pubkey -O - | sudo apt-key add -
cat > /etc/apt/sources.list.d/perforce.sources.list << MUFASA
deb http://package.perforce.com/apt/ubuntu precise release 
MUFASA

apt-get update
apt-get install -qq perforce-swarm perforce-swarm-triggers

su - vagrant -c "p4 user -i -f << MUFASA
User: $SWARMUSER
Password: $SWARMPASSWD
Email: swarm@priderock
FullName: swarm
MUFASA"
(cd /home/vagrant && \
su - vagrant -c 'p4 protect -o > add' && \
echo -e "\tadmin user $SWARMUSER * //..." >> add && \
su - vagrant -c 'p4 protect -i < add' && \
rm add)

/opt/perforce/swarm/sbin/configure-swarm.sh -p $P4PORT -u $SWARMUSER -w $SWARMPASSWD -U $P4USER -W $P4PASSWD -e localhost
(cd /opt/perforce/etc && \
sed -i 's#^\(SWARM_HOST\s*=\s*\).*$#\1"http://localhost"#' swarm-trigger.conf)
