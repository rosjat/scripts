for VERSION in $@
do
	echo "downloading $VERSION ..."
	wget -q --no-check-certificate https://download.nextcloud.com/server/releases/nextcloud-$VERSION.zip -P $NC_DOWNLOAD ;
	echo "done."
done