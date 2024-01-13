foo:= :

all : OC10toNC13 NC14toNC19 NC20toNC24 NC25toNC28

prepstage :
	docker build --target prepstage --progress=plain  -t migration:prepstage .
base16 : prepstage
	docker build --target base16 --progress=plain  -t migration:16v0.1 .
base18 : prepstage
	docker build --target base18 --progress=plain  -t migration:18v0.1 .
base20 : prepstage
	docker build --target base20 --progress=plain  -t migration:20v0.1 .
base22 : prepstage
	docker build --target base22 --progress=plain  -t migration:22v0.1 .

build-images :
	docker build --target prepstage --progress=plain  -t migration:prepstage .
	docker build --target base16 --progress=plain  -t migration:16v0.1 .
	docker build --target base18 --progress=plain  -t migration:18v0.1 .
	docker build --target base20 --progress=plain  -t migration:20v0.1 .
	docker build --target base22 --progress=plain  -t migration:22v0.1 .

OC10toNC13 :
	docker run --rm --env-file ${CURDIR}/env/base16.env  -e NC_VERSION="12.0.4" -v ${CURDIR}/$(foo)/owncloud migration$(foo)16v0.1   
	docker run --rm --env-file ${CURDIR}/env/base16.env  -e NC_VERSION="13.0.0" -v ${CURDIR}/$(foo)/owncloud migration$(foo)16v0.1   

NC14toNC19 : OC10toNC13
	docker run --rm --env-file ${CURDIR}/env/base18.env -e NC_VERSION="14.0.0" -v ${CURDIR}/$(foo)/owncloud migration$(foo)18v0.1   
	docker run --rm --env-file ${CURDIR}/env/base18.env -e NC_VERSION="15.0.0" -v ${CURDIR}/$(foo)/owncloud migration$(foo)18v0.1
	docker run --rm --env-file ${CURDIR}/env/base18.env -e NC_VERSION="16.0.10" -v ${CURDIR}/$(foo)/owncloud migration$(foo)18v0.1
	docker run --rm --env-file ${CURDIR}/env/base18.env -e NC_VERSION="17.0.10" -v ${CURDIR}/$(foo)/owncloud migration$(foo)18v0.1
	docker run --rm --env-file ${CURDIR}/env/base18.env -e NC_VERSION="18.0.14" -v ${CURDIR}/$(foo)/owncloud migration$(foo)18v0.1
	docker run --rm --env-file ${CURDIR}/env/base18.env -e NC_VERSION="19.0.13" -v ${CURDIR}/$(foo)/owncloud migration$(foo)18v0.1

NC20toNC24 : OC10toNC13 NC14toNC19
	docker run --rm --env-file ${CURDIR}/env/base20.env -e NC_VERSION="20.0.14" -v ${CURDIR}/$(foo)/owncloud migration$(foo)20v0.1   
	docker run --rm --env-file ${CURDIR}/env/base20.env -e NC_VERSION="21.0.9" -v ${CURDIR}/$(foo)/owncloud migration$(foo)20v0.1
	docker run --rm --env-file ${CURDIR}/env/base20.env -e NC_VERSION="22.2.10" -v ${CURDIR}/$(foo)/owncloud migration$(foo)20v0.1
	docker run --rm --env-file ${CURDIR}/env/base20.env -e NC_VERSION="23.0.12" -v ${CURDIR}/$(foo)/owncloud migration$(foo)20v0.1
	docker run --rm --env-file ${CURDIR}/env/base20.env -e NC_VERSION="24.0.12" -v ${CURDIR}/$(foo)/owncloud migration$(foo)20v0.1

NC25toNC28 : OC10toNC13 NC14toNC19 NC20toNC24
	docker run --rm --env-file ${CURDIR}/env/base22.env -e NC_VERSION="25.0.13" -v ${CURDIR}/$(foo)/owncloud migration$(foo)22v0.1   
	docker run --rm --env-file ${CURDIR}/env/base22.env -e NC_VERSION="26.0.10" -v ${CURDIR}/$(foo)/owncloud migration$(foo)22v0.1
	docker run --rm --env-file ${CURDIR}/env/base22.env -e NC_VERSION="27.1.5" -v ${CURDIR}/$(foo)/owncloud migration$(foo)22v0.1
	docker run --rm --env-file ${CURDIR}/env/base22.env -e NC_VERSION="28.0.1" -v ${CURDIR}/$(foo)/owncloud migration$(foo)22v0.1

clean :
	docker image prune -f

