#!/bin/bash

# For Debian 9 Stretch
# Checked in https://www.shellcheck.net/
# Written by Bahadır Doğru (bahadirdogru.com)

# Swap sources from https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04
# Multiline creating texts https://stackoverflow.com/questions/40562595/creating-an-output-file-with-multi-line-script-using-echo-linux
# Nginx Fail2ban configuration https://www.digitalocean.com/community/tutorials/how-to-protect-an-nginx-server-with-fail2ban-on-ubuntu-14-04

# Bismillah
clear;
echo "---*** Bismillah | Lets get started... ***---";
sleep 3;

# I do not use as a mail server3or any mail features. So delete exim packages.
clear;
echo "---*** We don't need any mail packages like exim4 ***---";
apt-get -y remove --purge exim4*; 

# I change ssh port to 22222. Do not use default never.
clear;
echo "---*** Changing SSH Ports ***---";
sleep 3;
sed -i 's/#Port 22/Port 22222/g' /etc/ssh/sshd_config;

# sed = Stream EDitor
# -i = in-place (orjinal dosyanın üzerine kaydet)
# Komut açıklamaları:
# s = substitute komut
# original = orjinal değer değiştirelecek olan
# new = değiştirilen yeni değer
# g = global (hepsini değiştir sadece ilkini değil)
# file.txt = dosya adı

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

# DotDeb repository.
clear;
echo "---*** Adding DotDeb repository ***---";
sleep 3;
cd /tmp || exit;
wget https://www.dotdeb.org/dotdeb.gpg;
apt-key add dotdeb.gpg;
rm dotdeb.gpg;
echo deb http://packages.dotdeb.org stretch all >> /etc/apt/sources.list;
echo deb-src http://packages.dotdeb.org stretch all >> /etc/apt/sources.list;

# I add latest stable nginx repositery.
clear;
echo "---*** Adding Nginx repository ***---";
sleep 3;
wget https://nginx.org/keys/nginx_signing.key;
apt-key add nginx_signing.key;
echo deb http://nginx.org/packages/debian/ stretch nginx >> /etc/apt/sources.list;
echo deb-src http://nginx.org/packages/debian/ stretch nginx >> /etc/apt/sources.list;

# Add Mysql Repository
# Get latest link from https://dev.mysql.com/downloads/repo/apt/
clear;
echo "---*** Adding Mysql repository ***---";
sleep 3;
wget https://dev.mysql.com/get/mysql-apt-config_0.8.8-1_all.deb
dpkg -i mysql-apt-config_0.8.8-1_all.deb
rm mysql-apt-config_0.8.8-1_all.deb

# Cleaning and updating server to be ready.
apt-get -y autoremove;
apt-get -y autoclean;
apt-get -y update;
apt-get -y upgrade;

# Install packages
clear;
echo "---*** Start Installation ***---";
sleep 3;
apt-get -y install nginx redis-server memcached unzip zip fail2ban php7.0-fpm php-redis php-memcached php7.0-mbstring php7.0-curl php7.0-gd php7.0-mcrypt php7.0-mysql php7.0-soap php7.0-xml php7.0-json php7.0-zip php7.0-cli php7.0-common mysql-server;
wget -O- https://raw.github.com/ajenti/ajenti/1.x/scripts/install-debian.sh | sh;
apt-get -y install ajenti-v ajenti-v-mysql ajenti-v-php7.0-fpm ajenti-v-ftp-pureftpd ajenti-v-nginx;

# FOR NODEJS PACKAGES
# curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -; # İnstall NodeJs Repository
# apt-get -y install nodejs;


# Fail2Ban Configuration
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local;
# bantime = 3600

sed -i 's/# bantime = 3600/bantime = 3600/g' /etc/fail2ban/jail.local;


# Configure Mysql Secure Installation
clear;
echo "---*** Configure Mysql ***---";
sleep 3;
mysql_secure_installation

# In Ajenti python files there is a forgotten bug. This code blocks correct that.
sed -i 's/("Access-Control-Max-Age", 3600)/("Access-Control-Max-Age", "3600")/g' /usr/share/pyshared/socketio/transports.py;
sed -i 's/("Access-Control-Max-Age", 3600)/("Access-Control-Max-Age", "3600")/g' /usr/share/pyshared/socketio/handler.py;
clear;
echo "Server-Automate Installation is ascomplished !!!";
echo " ";
echo "Ajenti Panel: https://ipadress:8000";
echo "SSH Port is now 22222";
echo "2GB Swap ram is configured";
echo "Php7 Nginx Mysql is installed and can be configured in Ajenti Panel";
echo "Server will be restart in 30 seconds";
sleep 30;
reboot
