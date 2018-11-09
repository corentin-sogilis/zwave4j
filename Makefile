IMAGE_NAME=zwave4j

WORKSPACE=workspace
DOCKER_USER_DESCRIPTION=-e "_USER=$(shell id -nu)" -e "_UID=$(shell id -u)" -e "_GID=$(shell id -g)"
DOCKER_WORKSPACE_DESCRIPTION=-e "WORKSPACE=$(WORKSPACE)" -v $(PWD):/$(WORKSPACE)/zwave4j -v $(PWD)/../open-zwave:/$(WORKSPACE)/open-zwave
DOCKER_CMD = docker run --rm $(DOCKER_WORKSPACE_DESCRIPTION) $(DOCKER_USER_DESCRIPTION) -e "GRADLE_USER_HOME=/$(WORKSPACE)/zwave4j/.gradle" -it $(IMAGE_NAME)

.PHONY : all build shell image clean

all: build

build :
	$(DOCKER_CMD) /$(WORKSPACE)/zwave4j/gradlew -p /$(WORKSPACE)/zwave4j build

shell :
	$(DOCKER_CMD) bash

image :
	docker build docker -t $(IMAGE_NAME)

clean :
	./gradlew clean
