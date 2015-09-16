#!/bin/bash -eux

WD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "${WD}/p4d/default"

wget -q http://package.perforce.com/perforce.pubkey -O - | apt-key add -
cat > /etc/apt/sources.list.d/perforce.sources.list << MUFASA
deb http://package.perforce.com/apt/ubuntu trusty release
MUFASA

apt-get update
apt-get install -qq helix-swarm helix-swarm-triggers

su - vagrant -c "p4 user -i -f << MUFASA
User: $SWARMUSER
Password: $SWARMPASSWD
Email: swarm@priderock
FullName: swarm
MUFASA"
(cd /home/vagrant && \
su - vagrant -c 'p4 protect -o > add' && \
sed -i '$d' add && \
echo -e "\tadmin user $SWARMUSER * //..." >> add && \
su - vagrant -c 'p4 protect -i < add' && \
rm add)

/opt/perforce/swarm/sbin/configure-swarm.sh -p $P4PORT -u $SWARMUSER -w $SWARMPASSWD -U $P4USER -W $P4PASSWD -e $(hostname) -H $(hostname -f)

curl -sS http://localhost/login -c cookie -d "user=${P4USER}&password=${P4PASSWD}" -o /dev/null
token=$(curl -sS http://localhost/about -b cookie | sed -nr 's#^.*token muted.*value="(.+)".*$#\1#p')
rm cookie
(cd /opt/perforce/etc && \
sed -i 's#^\(SWARM_HOST\s*=\s*\).*$#\1"http://'"$(hostname -f)"'"#' swarm-trigger.conf && \
sed -i 's#^\(SWARM_TOKEN\s*=\s*\).*$#\1"'$token'"#' swarm-trigger.conf && \
echo "localhost" >> swarm-cron-hosts.conf)

a2dissite 000-default
service apache2 reload
