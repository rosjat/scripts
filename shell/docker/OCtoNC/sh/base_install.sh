#!/bin/sh

set -eux;
if [ $NC_IMAGE_BASE -ne 16 ];
	then
		export TZ=Europe/Berlin;
fi;
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections; 
apt-get update; 
apt-get install -y --no-install-recommends \
		$1-$2 \
		php$3 \
		php$3-cli \
		php$3-fpm \
		php$3-pgsql \
		php$3-mysql \
		php$3-xml \
		php$3-curl \
		php$3-mbstring \
		php$3-gd \
		php$3-zip \
		php-redis \
		php-ldap \
		wget \
		unzip \
		netcat \
		redis-server \
; 
rm -rf /var/lib/apt/lists/*;
mkdir -p /var/www;
