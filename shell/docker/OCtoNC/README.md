Owncloud to Nextcloud Migration
===============================

Well in the end you could also migrate Nextcloud to Nextcloud but I guess this will be obvious after a while.
This is not very fancy nor is it aimed to be efficent! It's simply a helper to migrate a old database to an
up to date one ;-)

That said you will need to do the NExtcloud part still to get your data on the disk to the correct palce to be found by 
NExtcloud and this is all well documented by Nextcloud anyway.


Content
--------

* conf Folder -> some conf files you might need on the way, here its a simple redis.conf for specific builds
* env Folder -> placed the .env files for every image we use in there and you should edit your values as you see fit
* php Folder -> not very useful but you have to place the config.php in there. **Warning:** the Version in the file will be changed so keep a backup some place.
* sh folder -> all the little helpers that take care of things, feel free to go nuts here if you want something else or have a better approach ;-)
  * base_install.sh -> prepare all the software we need for the Nextcloud migration
  * utils.sh -> a few helper functions to do the work a little easier
  * nc_migrate.sh -> the "brain" of the migration, not very nice since I don't do shell scripts all the time but it gets the job done.
* sql Folder -> put the sql scripts in here you need/want to call. **Important:** the inital databes sql script goes in here too!
  * fix_upgrade_12.0.4.sql -> alter some things
  * fix_upgrade_14.0.0.sql -> delete some tables so the upgrade doesn't screams at you
  * owncloud.sql -> your init database
* Dockerfile -> blueprint for the Docker images and also open for your improvements!
* Makefile -> well we might wanna slimline some things so we use a Makefile with some targets

Build
---------

Well cd in the folder and run the Makefile with some args ...

* build your images 

	```
	$ make build-images
	```

* run the full migration 

	```
	$ make
	```

If you wanna run stages just look at the targets in the make file, you could easily write your own targest for your needs!


ToDo
--------

* get the build stage to work with build args to support mariadb and postgresql without changing the Dokcerfile