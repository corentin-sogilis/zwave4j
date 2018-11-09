IMAGE_NAME=zwave4j

WORKSPACE=workspace
DOCKER_USER_DESCRIPTION=-e "_USER=$(shell id -nu)" -e "_UID=$(shell id -u)" -e "_GID=$(shell id -g)"
DOCKER_WORKSPACE_DESCRIPTION=-e "WORKSPACE=$(WORKSPACE)" -v $(PWD):/$(WORKSPACE)/zwave4j -v $(PWD)/../open-zwave:/$(WORKSPACE)/open-zwave
DOCKER_CMD = docker run --rm $(DOCKER_WORKSPACE_DESCRIPTION) $(DOCKER_USER_DESCRIPTION) -e "GRADLE_USER_HOME=/$(WORKSPACE)/zwave4j/.gradle" -it $(IMAGE_NAME)

ZWAVE4J_NATIVE_LIBSDIR=build/libs/jniLibs
ZWAVE4J_NDK_OBJDIR = build/obj
OPENZWAVE_DIR := ../open-zwave


.PHONY : all build shell image clean

all: build $(ZWAVE4J_NATIVE_LIBSDIR)/libzwave.so

build :
	$(DOCKER_CMD) /$(WORKSPACE)/zwave4j/gradlew -p /$(WORKSPACE)/zwave4j build

shell :
	$(DOCKER_CMD) bash

image :
	docker build docker -t $(IMAGE_NAME)

clean :
	./gradlew clean

################################################################################

.PHONY: all clean

$(ZWAVE4J_NATIVE_LIBSDIR)/libzwave.so : $(OPENZWAVE_DIR)/cpp/src/vers.cpp jni_headers
	ndk-build -j8 NDK_LIBS_OUT=$(ZWAVE4J_NATIVE_LIBSDIR) NDK_OUT=$(ZWAVE4J_NDK_OBJDIR)

jni_headers :
	./gradlew generateNativeHeaders

$(OPENZWAVE_DIR)/cpp/src/vers.cpp :
	cd $(OPENZWAVE_DIR) && make cpp/src/vers.cpp
