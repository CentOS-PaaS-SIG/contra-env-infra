
IMAGE_NAME = jenkins
CONTAINER_NAME = $(IMAGE_NAME)-testapp

.PHONY: build
build:
	buildah bud -t $(IMAGE_NAME) .

.PHONY: test
test:
	buildah bud -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate CONTAINER_NAME=$(CONTAINER_NAME) test/run
