
IMAGE_NAME ?= tangfeixiong/weblogic
IMAGE_TAG ?= latest

DOCKER_BIN := $(shell which docker)

.PHONY: all oraclelinux centos

all: oraclelinux centos

oraclelinux centos:
	$(DOCKER_BIN) build -t $(IMAGE_NAME):$@-$(IMAGE_TAG) -f $@/Dockerfile .

