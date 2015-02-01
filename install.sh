#!/bin/bash -eux

for i in "$@"
do
	if [ -d "/vagrant/install/${i}" ]
	then
 		install=/vagrant/install/${i}/install.sh
	else
		install=/vagrant/install/${i}.sh
	fi

	chmod +x $install && eval $install
done
