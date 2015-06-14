#!/bin/bash
#
# Setup the the box. This runs as root


apt-get -y update
apt-get -y install curl wget nano

apt-get -y install python-software-properties software-properties-common

add-apt-repository -y ppa:saltstack/salt
apt-add-repository -y ppa:phalcon/stable

apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository -y 'deb http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.0/ubuntu trusty main'

apt-get -y update

# You can install anything you need here.

apt-get -y install php5-fpm php5-dev php5-mcrypt php5-cli php5-phalcon
apt-get -y install npm nginx-full 
apt-get -y install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
npm install -g bower
npm install -g grunt
npm install -g grunt-cli
apt-get -y install salt-minion

cd ~

curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin

curl -O https://www.kernel.org/pub/software/scm/git/git-2.4.3.tar.gz
tar xzf git-2.4.3.tar.gz
cd git-2.4.3
make configure
./configure --prefix=/usr
make all
make install
cd ..
rm -rf git-2.4.3
rm -rf git-2.4.3.tar.gz

git --version

curl -O http://download.redis.io/releases/redis-3.0.2.tar.gz
tar xzf redis-3.0.2.tar.gz
cd redis-3.0.2
make
make install
cd utils
./install_server.sh

apt-get -y autoremove

sed -i '/#master: salt/ s/#master: salt/#master: dragonflame.org/' /etc/salt/minion
