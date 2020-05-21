.PHONY: all build nginx clean mount umount

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DIST_DIR = ./dist

all: build

build:
	docker build --pull --rm --squash -f ./Dockerfile -t nginx-le .
#	docker save -o $(DIST_DIR)/nginx-le.tar nginx-le

start: build
	docker run --rm -it  -p 443:443/tcp -p 80:80/tcp nginx-le:latest

debug: build
	docker run --rm -it -p 127.0.0.1:3002:82/tcp nginx-le:latest

clean:
	-docker system prune
	-rm -rf $(DIST_DIR)/*

mount:
	sshfs scaleway: $(ROOT_DIR)/scaleway/ -o allow_other,defer_permissions,transform_symlinks,follow_symlinks

umount:
	umount $(ROOT_DIR)/scaleway/ 
