#!/bin/sh
set
set -eux;

if [ -e "$NC_DB_PATH/owncloud.sql" ];
	then
		echo "db file provided in $NC_DB_PATH ..";
		cp $NC_DB_PATH/owncloud.sql $PWD; 
		mv $NC_DB_PATH/owncloud.sql $NC_DB_PATH/owncloud.sql.org; 
elif [ -e "$NC_DB_OUTPUT_PATH/owncloud.sql" ];
	then
		echo "db file provided in $NC_DB_PATH ..";
		mv $NC_DB_OUTPUT_PATH/owncloud.sql $PWD; 
else
	echo "no db file provided in $NC_DB_PATH or $NC_DB_OUTPUT_PATH so we stop here!";
	exit 1;
fi;

echo "starting services ..."
if [ $NC_REDIS_CONF -a -e /owncloud/conf/$NC_REDIS_CONF ];
	then
	cp /owncloud/conf/$NC_REDIS_CONF /etc/redis/redis.conf; 
fi;
service redis-server start;
service postgresql start;
echo "done."
if [ $NC_CREATE_DB -eq 1 ];
	then
		echo "restore db from backup ..."
		su - postgres -c "psql -d $NC_DB < $PWD/owncloud.sql";
		echo "done."
		sh ./sh/fix.sh $NC_FIX_DB		
fi;
unzip -qo /download/nextcloud-$NC_VERSION.zip -d /var/www ; 
if [ "$NC_VERSION" = "18.0.14" ];
	then
		rm -f $NC_PATH/apps/workflowengine/appinfo/database.xml; 
fi;
cp $PWD/php/config.php $NC_PATH/config/ ; 
chown -R root:www-data $NC_PATH/ ; 
php $NC_PATH/occ upgrade;
if [ $NC_DB_BACKUP -eq 1 ];
	then 
		echo "backup db ..."
		PGPASSWORD=$NC_DB_OWNER_PW pg_dump  --quote-all-identifiers -U $NC_DB_OWNER -h localhost $NC_DB > /tmp/nextcloud.sql;
		mv /tmp/nextcloud.sql $NC_DB_OUTPUT_PATH/owncloud.sql; 
		echo "done.";
fi;
echo "starting upgrade ..."
cp $NC_PATH/config/config.php $PWD/php/config.php; 
echo "done."
echo "stopping services ..."
service redis-server stop;
service postgresql stop;
echo "done"