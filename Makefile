.PHONY: all build nginx clean

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DIST_DIR = ./dist

all: build

build: nginx

nginx:
	docker build --pull --rm --squash -f ./Dockerfile -t nginx-le .
	docker save -o $(DIST_DIR)/nginx-le.tar nginx-le

clean:
	-docker system prune -f
	-rm -rf $(DIST_DIR)/*
