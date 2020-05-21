.PHONY: all build deploy debug clean mount umount

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
REMOTE_DIR:=$(ROOT_DIR)/scaleway/
DIST_DIR = ./dist

all: build

build:
	docker build --pull --rm --squash -f ./Dockerfile -t nginx-le .

deploy: build
	mkdir -p $(DIST_DIR)
	docker save -o $(DIST_DIR)/nginx-le.tar nginx-le
	rsync -ahP $(DIST_DIR)/nginx-le.tar scaleway:~/docker/images

debug: build
	docker run --rm -it -p 127.0.0.1:3002:82/tcp -p 127.0.0.1:3000:80/tcp nginx-le:latest

clean:
	-docker system prune -f
	-rm -rf $(DIST_DIR)/*

mount:
	mkdir -p $(REMOTE_DIR)
	sshfs scaleway: $(REMOTE_DIR) -o allow_other,defer_permissions,transform_symlinks,follow_symlinks

umount:
	umount $(REMOTE_DIR)
