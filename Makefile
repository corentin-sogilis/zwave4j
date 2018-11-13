IMAGE_NAME=zwave4j

WORKSPACE=workspace
DOCKER_USER_DESCRIPTION=-e "_USER=$(shell id -nu)" -e "_UID=$(shell id -u)" -e "_GID=$(shell id -g)"
DOCKER_WORKSPACE_DESCRIPTION=-e "WORKSPACE=$(WORKSPACE)" -v $(PWD):/$(WORKSPACE)/zwave4j -v $(PWD)/../open-zwave:/$(WORKSPACE)/open-zwave
DOCKER_CMD = docker run --rm $(DOCKER_WORKSPACE_DESCRIPTION) $(DOCKER_USER_DESCRIPTION) -e "GRADLE_USER_HOME=/$(WORKSPACE)/zwave4j/.gradle" -it $(IMAGE_NAME)

ZWAVE4J_NATIVE_LIBSDIR=build/libs/jniLibs
OPENZWAVE_DIR := ../open-zwave

.PHONY : all shell image clean

all: build/libs/zwave4j-1.0-SNAPSHOT.jar $(ZWAVE4J_NATIVE_LIBSDIR)/libzwave.so

shell :
	$(DOCKER_CMD) bash

image :
	docker build docker -t $(IMAGE_NAME)

clean :
	rm -rf build

################################################################################

JAVA_SRC_FILES=$(wildcard src/main/java/org/zwave4j/*.java)

build/libs/zwave4j-1.0-SNAPSHOT.jar : $(JAVA_SRC_FILES)
	$(DOCKER_CMD) /$(WORKSPACE)/zwave4j/gradlew -p /$(WORKSPACE)/zwave4j build

################################################################################

JAVA_HEADERS=build/native-headers/org_zwave4j_Manager.h \
             build/native-headers/org_zwave4j_NativeLibraryLoader.h \
             build/native-headers/org_zwave4j_Options.h

$(ZWAVE4J_NATIVE_LIBSDIR)/libzwave.so : $(OPENZWAVE_DIR)/cpp/src/vers.cpp $(JAVA_HEADERS)
	ndk-build -j8 NDK_LIBS_OUT=$(ZWAVE4J_NATIVE_LIBSDIR) NDK_OUT=$(ZWAVE4J_NDK_OBJDIR)

# Java headers

build/native-headers/org_zwave4j_Manager.h : ./src/main/java/org/zwave4j/Manager.java
	./gradlew generateNativeHeaders

build/native-headers/org_zwave4j_NativeLibraryLoader.h : ./src/main/java/org/zwave4j/NativeLibraryLoader.java
	./gradlew generateNativeHeaders

build/native-headers/org_zwave4j_Options.h : ./src/main/java/org/zwave4j/Options.java
	./gradlew generateNativeHeaders

$(OPENZWAVE_DIR)/cpp/src/vers.cpp :
	cd $(OPENZWAVE_DIR) && make cpp/src/vers.cpp
