#!/bin/bash

# For Debian 10 Buster
# Checked in https://www.shellcheck.net/
# Written by Bahadır Doğru (bahadirdogru.com)

# Swap sources from https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04
# Multiline creating texts https://stackoverflow.com/questions/40562595/creating-an-output-file-with-multi-line-script-using-echo-linux
# Nginx Fail2ban configuration https://www.digitalocean.com/community/tutorials/how-to-protect-an-nginx-server-with-fail2ban-on-ubuntu-14-04
# Php7.4 explanation from https://tecadmin.net/install-php-debian-9-stretch/

# Bismillah
clear;
echo "---*** Bismillah | Lets get started... ***---";
sleep 3;

# I do not use as a mail server3or any mail features. So delete exim packages.
clear;
echo "---*** We don't need any mail packages like exim4 ***---";
apt-get -y remove --purge exim4*; 
apt-get -y remove --purge postfix*; 
# Cleaning
apt-get -y autoremove;
apt-get -y autoclean;


# I change ssh port to 22222. Do not use default never.
clear;
echo "---*** Changing SSH Ports ***---";
sleep 3;
sed -i 's/#Port 22/Port 22222/g' /etc/ssh/sshd_config;

# sed = Stream EDitor
# -i = in-place (orjinal dosyanın üzerine kaydet)
# Komut açıklamaları:
# s = substitute komut
# original = orjinal değer değiştirelecek olan
# new = değiştirilen yeni değer
# g = global (hepsini değiştir sadece ilkini değil)
# file.txt = dosya adı

# Swap memory configuring as 2 GB. Just change 2G if you want it.
echo "---*** Creating Swap Memory File ***---";
sleep 3;
fallocate -l  2G /swapfile;
chmod 600 /swapfile;
mkswap /swapfile;
swapon /swapfile;
echo /swapfile none swap sw 0 0 >> /etc/fstab;
sysctl vm.swappiness=10;
sysctl vm.vfs_cache_pressure=50;
echo vm.swappiness = 10 >>/etc/sysctl.conf;
echo vm.vfs_cache_pressure = 50 >>/etc/sysctl.conf;

# sury.org repository.
clear;
echo "---*** Adding sury.org repository ***---";
sleep 3;
cd /tmp || exit;
apt install ca-certificates apt-transport-https;
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -;
echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list;
rm apt.gpg;

# I add latest stable nginx repositery.
clear;
echo "---*** Adding Nginx repository ***---";
sleep 3;
wget https://nginx.org/keys/nginx_signing.key;
apt-key add nginx_signing.key;
echo deb http://nginx.org/packages/debian/ buster nginx >> /etc/apt/sources.list;
echo deb-src http://nginx.org/packages/debian/ buster nginx >> /etc/apt/sources.list;

# Add MariaDB Repository
# Get latest link from https://downloads.mariadb.org/mariadb/repositories/#mirror=digitalocean-ams
clear;
echo "---*** Adding  MariaDB repository ***---";
sleep 3;
apt-get install software-properties-common dirmngr
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://ams2.mirrors.digitalocean.com/mariadb/repo/10.5/debian buster main'



# Cleaning and updating server to be ready.
apt-get -y autoremove;
apt-get -y autoclean;
apt-get -y update;
apt-get -y upgrade;

# this package not in debian10 so we install manuelly:
apt-get install python-pil
wget http://ftp.br.debian.org/debian/pool/main/p/pillow/python-imaging_4.0.0-4+deb9u1_all.deb
dpkg -i dpkg -i python-imaging_4.0.0-4+deb9u1_all.deb

# Install packages
clear;
echo "---*** Start Installation ***---";
sleep 3;
apt-get -y install nginx unzip zip fail2ban php7.4 php7.4-fpm php7.4-mbstring php7.4-curl php7.4-gd php7.4-mysql php7.4-soap php7.4-xml php7.4-json php7.4-zip php7.4-cli php7.4-opcache php7.4-common php7.4-readline mariadb-server;
# optional? redis-server memcached php-redis php-memcached

wget -O- https://raw.github.com/ajenti/ajenti/1.x/scripts/install-debian.sh | sh;
apt-get -y install ajenti-v ajenti-v-mysql ajenti-v-php7.4-fpm ajenti-v-ftp-pureftpd ajenti-v-nginx;

# Install Composer
curl -sS https://getcomposer.org/installer | php;
mv composer.phar /usr/local/bin/composer;
composer self-update;

# Fail2Ban Configuration
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local;
# bantime = 3600

sed -i 's/# bantime = 3600/bantime = 3600/g' /etc/fail2ban/jail.local;


# Configure Mysql Secure Installation
clear;
echo "---*** Configure Mysql ***---";
sleep 3;
mysql_secure_installation

# In Ajenti python files there is a forgotten bug. This code blocks correct that. and double it.
sed -i 's/("Access-Control-Max-Age", 3600)/("Access-Control-Max-Age", "7200")/g' /usr/share/pyshared/socketio/transports.py;
sed -i 's/("Access-Control-Max-Age", 3600)/("Access-Control-Max-Age", "7200")/g' /usr/share/pyshared/socketio/handler.py;
clear;
echo "Server-Automate Installation is ascomplished !!!";
echo " ";
echo "Ajenti Panel: https://ipadress:8000";
echo "SSH Port is now 22222";
echo "2GB Swap ram is configured";
echo "Php7.4 Nginx MariaDB15 is installed and can be configured in Ajenti Panel";
echo "Server will be restart in 30 seconds";
sleep 30;
reboot
