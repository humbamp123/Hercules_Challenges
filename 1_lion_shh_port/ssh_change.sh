#!/bin/sh
apt-get update
apt-get upgrade
apt-get --assume-yes install openssh-server
sed -i -e 's/Port 22/Port 50888/g' /etc/ssh/sshd_config
service ssh restart
