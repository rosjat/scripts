#!/bin/bash

set
set -eux;

do_migration() {
	# lets make some helpers for the whole thing ...
	local redis_conf_path=$PWD/conf
	local redis_path=/etc/redis/
	local nc_backup_file=nextcloud.sql
	local oc_file=owncloud.sql
	local php_path=$PWD/php
	local nc_config_path=$NC_PATH/config

	mkdir -p $NC_DB_OUTPUT_PATH

	if [ -e "$NC_DB_PATH/owncloud.sql" ];
		then
			echo "db file provided in $NC_DB_PATH ..";
			cp $NC_DB_PATH/$oc_file $PWD; 
			mv $NC_DB_PATH/$oc_file $NC_DB_PATH/$oc_file.org; 
	elif [ -e "$NC_DB_OUTPUT_PATH/$oc_file" ];
		then
			echo "db file provided in $NC_DB_PATH ..";
			mv $NC_DB_OUTPUT_PATH/$oc_file $PWD; 
	else
		echo "no db file provided in $NC_DB_PATH or $NC_DB_OUTPUT_PATH so we stop here!";
		exit 1;
	fi;

	if [ $NC_REDIS_CONF -a -e $redis_conf_path/$NC_REDIS_CONF ];
		then
		cp $redis_conf_path/$NC_REDIS_CONF $redis_path/redis.conf; 
	fi;
	echo "starting services ..."
	service redis-server start;
	service postgresql start;
	echo "done."
	if [ $NC_CREATE_DB -eq 1 ];
		then
			echo "restore db from backup ..."
			bash ./sh/utils.sh nc_init_db $NC_DB_SERVER $NC_DB_SERVER_VERSION $NC_DB $NC_DB_OWNER $NC_DB_OWNER_PW
			echo "done."	
	fi;
	echo "starting upgrade ..."
	bash ./sh/utils.sh nc_upgrade $NC_VERSION $NC_PATH
	echo "done."
	if [ $NC_DB_BACKUP -eq 1 ];
		then 
			echo "backup db ..."
			bash ./sh/utils.sh nc_backup $NC_DB $NC_DB_OWNER $NC_DB_OWNER_PW $NC_DB_OUTPUT_PATH $nc_backup_file
			echo "done.";
	fi;
	cp $nc_config_path/config.php $php_path/config.php; 
	echo "stopping services ..."
	service redis-server stop;
	service postgresql stop;
	echo "done"
}

do_migration