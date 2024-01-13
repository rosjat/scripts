echo $@
for VERSION in $@
	do
		if [ $VERSION = $NC_VERSION ];
			then
				echo "running fix_upgrade_$VERSION.sql ..."
				su - postgres -c "psql -d $NC_DB < $PWD/sql/fix_upgrade_$VERSION.sql";
				echo "done."
		fi

done