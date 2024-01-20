foo:= :
base ?= 16
version ?= 0.1
nc_versions ?= '12.0.4' '13.0.0' '14.0.0' '15.0.0' '16.0.10' '17.0.10' '18.0.14' '19.0.13' '20.0.14' '21.0.9' '22.2.10' '23.0.12' '24.0.12' '25.0.13' '26.0.10' '27.1.5' '28.0.1'
nc_version ?= 12.0.4

all : 
	for ver in $(nc_versions);do\
		if [ $$ver = '12.0.4' -o $$ver = '13.0.0' ];\
			then\
				make migrate base=16 version=$(version) nc_version=$$ver;\
		fi;\
		if [ $$ver = '14.0.0' -o $$ver = '15.0.0' -o $$ver = '16.0.10' -o $$ver = '17.0.10' -o $$ver = '18.0.14' -o $$ver = '19.0.13' ];\
			then\
				make migrate base=18 version=$(version) nc_version=$$ver;\
		fi;\
		if [ $$ver = '20.0.14' -o $$ver = '21.0.9' -o $$ver = '22.2.10' -o $$ver = '23.0.12' -o $$ver = '24.0.12' ];\
			then\
				make migrate base=20 version=$(version) nc_version=$$ver;\
		fi;\
		if [ $$ver = '25.0.13' -o $$ver = '26.0.10' -o $$ver = '27.1.5' -o $$ver = '28.0.1' ];\
			then\
				make migrate base=22 version=$(version) nc_version=$$ver;\
		fi;\
	done 

prepstage :
	docker build --target prepstage --progress=plain  -t migration:prepstage .

.PHONY : build prepstage

build : prepstage
	docker build --target base$(base) --progress=plain  -t migration:$(base)v$(version)  .

build-images :
	for ver in '16' '18' '20' '22';do\
		make build base="$$ver" version=$(version);\
	done

migrate : 
	docker run --rm --env-file ${CURDIR}/env/base.env --env-file ${CURDIR}/env/base$(base).env  -e NC_VERSION="$(nc_version)" -v ${CURDIR}/$(foo)/owncloud migration$(foo)$(base)v$(version);

clean :
	docker image prune -f

