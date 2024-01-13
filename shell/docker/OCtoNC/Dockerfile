####################################################################################################
#                                       BASE IMAGES										           #
#																							       #
# Define some basse images for postgresql and php needed for oc10.0.3 to nc 12.0.4 up to 25        #
#																								   #
#																								   #
# to ease the pain we would build images from base first. do we would build a migration:baseXX     #
#																								   #
# $ docker build --target base16 -t migration:base16 .											   #
#																								   #
####################################################################################################
FROM ubuntu:16.04 as prepstage

ENV NC_DOWNLOAD="/download"
ENV NC_DL_VERSIONS="12.0.4 13.0.0 14.0.0 15.0.0 16.0.10 17.0.10 18.0.14 19.0.13 20.0.14 21.0.9 \
                    22.2.10 23.0.12 24.0.12 25.0.13 26.0.10 27.1.5 28.0.1"
WORKDIR /owncloud

RUN mkdir -p $NC_DOWNLOAD
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
			wget \
	; \
	rm -rf /var/lib/apt/lists/*;

COPY ./sh/download.sh ./sh/download.sh

RUN sh $PWD/sh/download.sh $NC_DL_VERSIONS

COPY ./sh ./sh
COPY ./conf ./conf
COPY ./sql ./sql

### Base for OC 10.0.3 to NC 12.0.4 up to 13
FROM prepstage as base16

# some vars we might need later on ...
ENV NC_DOWNLOAD="/download"
ENV NC_DB_OWNER="owncloud_dbo"
ENV NC_DB="owncloud"
ENV NC_DB_OWNER_PW="very_secret_password"
ENV NC_VERSION="12.0.4"	
ENV NC_PATH="/var/www/nextcloud"
ENV NC_DB_PATH="/owncloud/sql"
ENV NC_DB_OUTPUT_PATH="/owncloud/result"
ENV NC_CREATE_DB=0
ENV NC_DB_BACKUP=0
ENV NC_FIX_DB="12.0.4 14.0.0"
ENV NC_IMAGE_BASE=16
ENV NC_REDIS_CONF=""

EXPOSE 5432
WORKDIR /owncloud

COPY ./sh/base.sh ./sh/base.sh

RUN sh $PWD/sh/base.sh "9.5" "7.0"

RUN mkdir -p /download
COPY --from=prepstage /download/ /download
COPY --from=migration:prepstage /owncloud/ .

ENTRYPOINT sh $PWD/sh/migrate.sh

### Base for NC  13 to 19
FROM ubuntu:18.04 as base18

# some vars we might need later on ...
ENV NC_DB_OWNER="owncloud_dbo"
ENV NC_DB="owncloud"
ENV NC_DB_OWNER_PW="very_secret_passwor"
ENV NC_VERSION="14.0.0"
ENV NC_PATH="/var/www/nextcloud"
ENV NC_CREATE_DB=0
ENV NC_DB_BACKUP=0
ENV NC_FIX_DB="12.0.4 14.0.0"
ENV NC_IMAGE_BASE=18
ENV NC_REDIS_CONF="redis18.conf"
ENV NC_DB_PATH="/owncloud/sql"
ENV NC_DB_OUTPUT_PATH="/owncloud/result"



EXPOSE 5432
WORKDIR /owncloud

COPY ./sh/base.sh ./sh/base.sh

RUN sh $PWD/sh/base.sh "10" "7.2"

RUN mkdir -p /download
COPY --from=prepstage /download/ /download
COPY --from=migration:prepstage /owncloud/ .

ENTRYPOINT sh $PWD/sh/migrate.sh

### Base for NC  20 to 24
FROM ubuntu:20.04 AS base20

# some vars we might need later on ...
ENV NC_DB_OWNER="owncloud_dbo"
ENV NC_DB="owncloud"
ENV NC_DB_OWNER_PW="very_secret_passwor"
ENV NC_VERSION="20.0.14"
ENV NC_PATH="/var/www/nextcloud"
ENV NC_CREATE_DB=0
ENV NC_DB_BACKUP=0
ENV NC_FIX_DB=0
ENV NC_FIX_DB_FILE=""
ENV NC_IMAGE_BASE=20
ENV NC_REDIS_CONF="redis.conf"
ENV NC_DB_PATH="/owncloud/sql"
ENV NC_DB_OUTPUT_PATH="/owncloud/result"

EXPOSE 5432
WORKDIR /owncloud

COPY ./sh/base.sh ./sh/base.sh

RUN sh $PWD/sh/base.sh "12" "7.4"

RUN mkdir -p /download
COPY --from=prepstage /download/ /download
COPY --from=migration:prepstage /owncloud/  .

ENTRYPOINT sh $PWD/sh/migrate.sh

### Base for NC  25 to 28
FROM ubuntu:22.04 AS base22

# some vars we might need later on ...
ENV NC_DB_OWNER="owncloud_dbo"
ENV NC_DB="owncloud"
ENV NC_DB_OWNER_PW="very_secret_passwor"
ENV NC_VERSION="25.0.13"
ENV NC_PATH="/var/www/nextcloud"
ENV NC_CREATE_DB=0
ENV NC_DB_BACKUP=0
ENV NC_FIX_DB=0
ENV NC_FIX_DB_FILE=""
ENV NC_IMAGE_BASE=22
ENV NC_REDIS_CONF=""
ENV NC_DB_PATH="/owncloud/sql"
ENV NC_DB_OUTPUT_PATH="/owncloud/result"

EXPOSE 5432
WORKDIR /owncloud

COPY ./sh/base.sh ./sh/base.sh

RUN sh $PWD/sh/base.sh "14" "8.1"

RUN mkdir -p /download
COPY --from=prepstage /download/ /download
COPY --from=migration:prepstage /owncloud/ .

ENTRYPOINT sh $PWD/sh/migrate.sh
