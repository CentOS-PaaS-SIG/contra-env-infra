
IMAGE_NAME = linchpin
CONTAINER_NAME = $(IMAGE_NAME)-test

USERNAME ?= dummy_username
PASSWORD ?= dummy_password
VERSION ?= dummy_version
CONTAINER_REGISTRY ?= docker://docker.io
CONTAINER_NAMESPACE ?= contrainfra

.PHONY: build
build:
	buildah bud -t $(IMAGE_NAME) .

.PHONY: test
test:
	buildah bud -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate CONTAINER_NAME=$(CONTAINER_NAME) test/run

.PHONY: push
push:
	buildah push --creds $(USERNAME)\:$(PASSWORD) localhost/$(IMAGE_NAME)-candidate\:$(VERSION) \
    $(CONTAINER_REGISTRY)/$(CONTAINER_NAMESPACE)/$(IMAGE_NAME)\:$(VERSION)


