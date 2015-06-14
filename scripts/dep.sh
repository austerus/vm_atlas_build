#!/bin/bash
#
# Setup the the box. This runs as root


apt-get -y update
apt-get -y install curl wget nano

apt-get -y install python-software-properties software-properties-common >/dev/null

add-apt-repository -y ppa:saltstack/salt
apt-add-repository -y ppa:phalcon/stable

apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository -y 'deb http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.0/ubuntu trusty main'

apt-get -y update

# You can install anything you need here.

apt-get install -y php5-fpm php5-dev php5-mcrypt php5-cli php5-phalcon >/dev/null
apt-get install -y npm nginx-full >/dev/null
apt-get install -y libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev >/dev/null
npm install -g bower >/dev/null
npm install -g grunt >/dev/null
npm install -g grunt-cli >/dev/null
apt-get -y install salt-minion >/dev/null

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password root'
apt-get install -y mariadb-server
#mysql -uroot -pPASS -e "SET PASSWORD = PASSWORD('');"

cd ~

curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin

curl -O https://www.kernel.org/pub/software/scm/git/git-2.4.3.tar.gz
tar xzf git-2.4.3.tar.gz
cd git-2.4.3
make configure
./configure --prefix=/usr
make all >/dev/null
make install >/dev/null

cd ~

rm -rf git-2.4.3
rm -rf git-2.4.3.tar.gz

git --version

curl -O http://download.redis.io/releases/redis-3.0.2.tar.gz
tar xzf redis-3.0.2.tar.gz
cd redis-3.0.2
make >/dev/null
make install >/dev/null
cd utils
./install_server.sh

cd ~
rm -rf redis-3.0.2

apt-get -y autoremove

sed -i '/#master: salt/ s/#master: salt/#master: dragonflame.org/' /etc/salt/minion
