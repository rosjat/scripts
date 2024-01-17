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
	#docker build --target prepstage --progress=plain  -t migration:prepstage .
	for ver in '16' '18' '20' '22';do\
		docker build --target base"$$ver" --progress=plain  -t migration$(foo)"$$ver"v0.1 .;\
	done

OC10toNC13 :
	for ver in '12.0.4' '13.0.0';do\
		docker run --rm --env-file ${CURDIR}/env/base.env --env-file ${CURDIR}/env/base16.env  -e NC_VERSION="$$ver" -v ${CURDIR}/$(foo)/owncloud migration$(foo)16v0.1;\
	done

NC14toNC19 : OC10toNC13
	for ver in '14.0.0' '15.0.0' '16.0.10' '17.0.10' '18.0.14' '19.0.13';do\
		docker run --rm --env-file ${CURDIR}/env/base.env --env-file ${CURDIR}/env/base18.env -e NC_VERSION="$$ver" -v ${CURDIR}/$(foo)/owncloud migration$(foo)18v0.1;\
	done   

NC20toNC24 : OC10toNC13 NC14toNC19
	for ver in '20.0.14' '21.0.9' '22.2.10' '23.0.12' '24.0.12';do\
		docker run --rm --env-file ${CURDIR}/env/base.env --env-file ${CURDIR}/env/base20.env -e NC_VERSION="$$ver" -v ${CURDIR}/$(foo)/owncloud migration$(foo)20v0.1;\
	done

NC25toNC28 : OC10toNC13 NC14toNC19 NC20toNC24
	for ver in '25.0.13' '26.0.10' '27.1.5' '28.0.1';do\
		docker run --rm --env-file ${CURDIR}/env/base.env --env-file ${CURDIR}/env/base22.env -e NC_VERSION="$$ver" -v ${CURDIR}/$(foo)/owncloud migration$(foo)22v0.1;\
	done

clean :
	docker image prune -f

