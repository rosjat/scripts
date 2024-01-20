
# usage: nc_download  path ver1 ver2 ver3
#    ie: nc_download ~/dl 13.0.0 14.0.0
# will download nextloud releases into the provided path 
nc_download() {
	local dest="${@: -1}"
	local versions=${@:1:$#-1}
	for version in $versions;
	do
		echo "downloading $version ..."
		wget -q --no-check-certificate https://download.nextcloud.com/server/releases/nextcloud-$version.zip -P $dest ;
		echo "done."
	done
}

nc_fix_db() {
    local dest="${@: -1}"
	local versions=${@:1:$#-1}
    for version in $versions;
	do
		if [ $version = $NC_VERSION ];
			then
				echo "running fix_upgrade_$version.sql ..."
				su - postgres -c "psql -d $NC_DB < $dest/fix_upgrade_$version.sql";
				echo "done."
		fi
done
}

nc_init_postgres_db() {
	local srv_ver=$1
	local db=$2
	local db_owner=$3
	local db_owner_pw=$4
	mkdir -p /var/postgresql/data;
	chown -R postgres:postgres /var/postgresql/data; 
	su - postgres -c "/usr/lib/postgresql/$srv_ver/bin/initdb -D /var/postgresql/data -U postgres -E UTF8 -A md5 -W;"; 
	su - postgres -c "psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres <<-EOSQL
			CREATE USER $db_owner WITH PASSWORD '$db_owner_pw';
			CREATE DATABASE $db OWNER $db_owner;
			GRANT ALL PRIVILEGES ON DATABASE $db TO $db_owner;
	EOSQL"
	su - postgres -c "psql -d $db < $PWD/owncloud.sql";
	nc_fix_db $NC_FIX_DB $PWD/sql
}

nc_init_maria_db() {
	local db=$1
	local db_owner=$2
	local db_owner_pw=$3
	if [ $NC_IMAGE_BASE -ne 22 ];
		then
			su -c "mysql -S /var/run/mysqld/mysqld.sock <<-EOSQL
				CREATE USER $db_owner IDENTIFIED BY '$db_owner_pw';
				CREATE DATABASE $db;
				GRANT ALL PRIVILEGES ON $db.* TO '$db_owner'@'%';
			EOSQL";
			su -c "mysql -S /var/run/mysqld/mysqld.sock $db < $PWD/owncloud.sql";
	else
		su -c "mariadb  -S /var/run/mysqld/mysqld.sock  <<-EOSQL
				CREATE USER $db_owner IDENTIFIED BY '$db_owner_pw';
				CREATE DATABASE $db;
				GRANT ALL PRIVILEGES ON $db.* TO '$db_owner'@'%';
		EOSQL";
		su -c "mariadb -S /var/run/mysqld/mysqld.sock $db < $PWD/owncloud.sql";
	fi;
}

nc_init_db() {
	local srv=$1
	local srv_ver=$2
	local db=$3
	local db_owner=$4
	local db_owner_pw=$5
	# we installed postgresql 
	if [ $srv = "postgresql" ];
		then
			echo "foo"
			nc_init_postgres_db $srv_ver $db $db_owner $db_owner_pw 
	fi;
	# we installed mariaDB
	if [ $1 = "mariadb-server" ];
		then
			nc_init_maria_db $db $db_owner $db_owner_pw 
	fi;
}

nc_upgrade() {
	local ver=$1
	local ncp=$2
	unzip -qo /download/nextcloud-$ver.zip -d /var/www ; 
	if [ "$ver" = "18.0.14" ];
		then
			rm -f $ncp/apps/workflowengine/appinfo/database.xml; 
	fi;
	cp $PWD/php/config.php $ncp/config/ ; 
	chown -R root:www-data $ncp/ ; 

	php $ncp/occ upgrade;
}

nc_backup() {
	local db=$1
	local db_owner=$2
	local db_owner_pw=$3
	local output_path=$4
	local db_backup_file=$5
	if [ $NC_DB_SERVER = "postgresql" ];
		then
			PGPASSWORD=$db_owner_pw pg_dump  --quote-all-identifiers -U $db_owner -h localhost $db > /tmp/$db_backup_file;
	else
		mysqldump --user=$db_owner  --password=$db_owner_pw --lock-tables --socket /var/run/mysqld/mysqld.sock  --databases $db > /tmp/$db_backup_file;
	fi;
	mv /tmp/$db_backup_file $output_path/owncloud.sql; 
}

"$@"