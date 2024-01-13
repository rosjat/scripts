#!/bin/sh

set -eux;
if [ $NC_IMAGE_BASE -ne 16 ];
	then
		export TZ=Europe/Berlin;
fi;
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections; 
apt-get update; 
apt-get install -y --no-install-recommends \
		postgresql-$1 \
		php$2 \
		php$2-cli \
		php$2-fpm \
		php$2-pgsql \
		php$2-xml \
		php$2-curl \
		php$2-mbstring \
		php$2-gd \
		php$2-zip \
		php-redis \
		php-ldap \
		wget \
		unzip \
		netcat \
		redis-server \
; 
rm -rf /var/lib/apt/lists/*;
mkdir -p /var/postgresql/data;
mkdir -p /var/www;
chown -R postgres:postgres /var/postgresql/data; \
su - postgres -c "/usr/lib/postgresql/$1/bin/initdb -D /var/postgresql/data -U postgres -E UTF8 -A md5 -W;"; 
service postgresql start;
su - postgres -c "psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres <<-EOSQL
		CREATE USER $NC_DB_OWNER WITH PASSWORD '$NC_DB_OWNER_PW';
		CREATE DATABASE $NC_DB OWNER $NC_DB_OWNER;
		GRANT ALL PRIVILEGES ON DATABASE $NC_DB TO $NC_DB_OWNER;
EOSQL"
service postgresql stop;