LD = $(NDK_HOME)/../../ndk-arm-v7a-toolchain/bin/arm-linux-androideabi-g++
CC = $(NDK_HOME)/../../ndk-arm-v7a-toolchain/bin/arm-linux-androideabi-g++

SRCDIR = src/main/cpp
SRC = $(wildcard $(SRCDIR)/*.cpp)
INCLUDEDIR = $(SRCDIR)
INCLUDE = -I$(INCLUDEDIR) -I$(OPENZWAVE_DIR)/cpp/src
LDFLAGS =  -shared
CFLAGS = -fPIC -Wall -Wno-unknown-pragmas -Wno-format -Wno-error=sequence-point -Wno-sequence-point -O3 -DNDEBUG $(INCLUDE)

OPENZWAVE_DIR ?= ../open-zwave
OPENZWAVE_OBJDIR = $(OPENZWAVE_DIR)/.lib
ZWAVE4J_JARDIR = build/libs
ZWAVE4J_JAR = $(ZWAVE4J_JARDIR)/zwave4j-1.0-SNAPSHOT.jar
ZWAVE4J_NATIVE_LIBSDIR=$(ZWAVE4J_JARDIR)/native_libs/linux/arm
ZWAVE4J_JNI_CLASSES = org.zwave4j.Manager org.zwave4j.Options
ZWAVE4J_JNI_INCLUDE_DIR = build/jni_include
LIBZWAVE4J_BUILDDIR = build/libzwave4j
JAVA_HOME = $(shell java -XshowSettings:properties -version 2>&1 | grep java.home | cut -d= -f2)
JAVA_INCLUDE = -I$(JAVA_HOME)/../include -I$(JAVA_HOME)/../include/linux

OBJ = $(patsubst $(SRCDIR)/%.cpp,$(LIBZWAVE4J_BUILDDIR)/%.o,$(SRC))

LIBZWAVE4J_TARGET = $(LIBZWAVE4J_BUILDDIR)/libzwave4j.so

.PHONY: all clean openzwave javah_headers run

all: zwave4j $(LIBZWAVE4J_TARGET)

$(LIBZWAVE4J_TARGET): $(LIBZWAVE4J_BUILDDIR) $(ZWAVE4J_JNI_INCLUDE_DIR) openzwave javah_headers $(OBJ)
	$(LD) $(LDFLAGS) -Wl,-fPIC,-soname,$@ $(wildcard $(LIBZWAVE4J_BUILDDIR)/*.o) -o $@
	mkdir -p $(ZWAVE4J_NATIVE_LIBSDIR)
	cp $(LIBZWAVE4J_TARGET) $(ZWAVE4J_NATIVE_LIBSDIR)/

$(LIBZWAVE4J_BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	$(CC) $(CFLAGS) -I$(ZWAVE4J_JNI_INCLUDE_DIR) $(JAVA_INCLUDE) -c  -o $@ $^

openzwave:
	make -C $(OPENZWAVE_DIR) android
	cp $(OPENZWAVE_OBJDIR)/*.o $(LIBZWAVE4J_BUILDDIR)
#	rm $(LIBZWAVE4J_BUILDDIR)/Main.o  # Remove Main.o from MinOZW

javah_headers:
	javah -d $(ZWAVE4J_JNI_INCLUDE_DIR) -cp $(ZWAVE4J_JAR) $(ZWAVE4J_JNI_CLASSES)

$(LIBZWAVE4J_BUILDDIR):
	mkdir -p $@

$(ZWAVE4J_JNI_INCLUDE_DIR):
	mkdir -p $@

zwave4j:
	gradle -b minimal.build.gradle build

clean:
	rm -r build

run:
	java -cp "$(ZWAVE4J_JAR):$(ZWAVE4J_JARDIR)" org.zwave4j.Main $(OPENZWAVE_DIR)
