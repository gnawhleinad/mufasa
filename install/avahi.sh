#!/bin/bash

apt-get update
apt-get install -qq avahi-daemon libnss-mdns

sed -i 's/^#\(domain-name\)\s*.*$/\1=test/' /etc/avahi/avahi-daemon.conf

cat > /etc/mdns.allow << MUFASA
.test.
.test
MUFASA

sed -i 's/^\(hosts:.*\)$/\1 mdns/' /etc/nsswitch.conf

service avahi-daemon restart
