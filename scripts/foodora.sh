#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y autoclean

apt-get -y update
apt-get install -y curl wget
apt-get install -y locales

dpkg-reconfigure locales && locale-gen en_US.UTF-8

apt-get -y install build-essential python-software-properties software-properties-common > /dev/null
apt-get install -y libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev autoconf > /dev/null

add-apt-repository -y ppa:ondrej/php5
add-apt-repository -y ppa:saltstack/salt
apt-add-repository -y ppa:brightbox/ruby-ng

curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get -y update

# You can install anything you need here.
apt-get install -y salt-minion > /dev/null

cd ~

wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key > /dev/null

add-apt-repository -y 'deb http://nginx.org/packages/ubuntu trusty nginx'
add-apt-repository -y 'deb-src http://nginx.org/packages/ubuntu trusty nginx'

rm -f nginx_signing.key

curl -O https://www.kernel.org/pub/software/scm/git/git-2.7.0.tar.gz
tar xzf git-2.7.0.tar.gz
cd git-2.7.0
make configure
./configure --prefix=/usr
make all > /dev/null
make install > /dev/null

cd ~

rm -rf git-2.7.0
rm -rf git-2.7.0.tar.gz

curl -O http://download.redis.io/releases/redis-3.0.7.tar.gz
tar xzf redis-3.0.7.tar.gz
cd redis-3.0.7
make > /dev/null
make install > /dev/null
cd utils
./install_server.sh

cd ~

rm -rf redis-3.0.7
rm -rf redis-3.0.7.tar.gz

pecl install redis
bash -c "echo extension=redis.so > /etc/php5/mods-available/redis.ini"

bash -c "echo export COUNTRY_CODE=de > ~/.bashrc"
bash -c "echo export SYMFONY_ENV=dev > ~/.bashrc"

apt-get purge apache2

apt-get -y autoremove
apt-get -y autoclean

sed -i '/#master: salt/ s/#master: salt/master: 127.0.0.1/' /etc/salt/minion
sed -i '/#file_client: remote/ s/#file_client: remote/file_client: local/' /etc/salt/minion

service salt-minion restart
