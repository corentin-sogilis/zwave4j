ZWAVE4J_JARDIR = build/libs
ZWAVE4J_JAR = $(ZWAVE4J_JARDIR)/zwave4j-1.0-SNAPSHOT.jar
ZWAVE4J_NATIVE_LIBSDIR=$(ZWAVE4J_JARDIR)/jniLibs
ZWAVE4J_JNI_CLASSES = org.zwave4j.Manager org.zwave4j.Options org.zwave4j.NativeLibraryLoader
ZWAVE4J_NDK_OBJDIR = build/obj

ZWAVE4J_JNI_INCLUDE_DIR = build/jni_include

.PHONY: all zwave4j_classes javah_headers openzwave clean run

all: zwave4j_classes javah_headers openzwave

zwave4j_classes:
	gradle -b minimal.build.gradle build

javah_headers: $(ZWAVE4J_JNI_INCLUDE_DIR)
	javah -d $(ZWAVE4J_JNI_INCLUDE_DIR) -cp $(ZWAVE4J_JAR) $(ZWAVE4J_JNI_CLASSES)

openzwave:
	ndk-build -j8 NDK_LIBS_OUT=$(ZWAVE4J_NATIVE_LIBSDIR) NDK_OUT=$(ZWAVE4J_NDK_OBJDIR)

$(ZWAVE4J_JNI_INCLUDE_DIR):
	mkdir -p $@

clean:
	rm -rf build

run:
	java -cp "$(ZWAVE4J_JAR):$(ZWAVE4J_JARDIR)" org.zwave4j.Main $(OPENZWAVE_DIR)
