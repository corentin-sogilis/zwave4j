LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_LDLIBS    := -llog
LOCAL_CPP_FEATURES := exceptions

OPENZWAVE_DIR := $(LOCAL_PATH)/../../open-zwave

OZW_MAIN_LIST = $(wildcard $(OPENZWAVE_DIR)/cpp/src/aes/*.c				\
                           $(OPENZWAVE_DIR)/cpp/src/command_classes/*.cpp	\
                           $(OPENZWAVE_DIR)/cpp/src/value_classes/*.cpp		\
                           $(OPENZWAVE_DIR)/cpp/src/platform/*.cpp			\
                           $(OPENZWAVE_DIR)/cpp/src/platform/unix/*.cpp		\
                           $(OPENZWAVE_DIR)/cpp/src/*.cpp)

$(warning $(OZW_MAIN_LIST))

OZW_TINYXML_LIST = $(wildcard $(OPENZWAVE_DIR)/cpp/tinyxml/*.cpp)

ZWAVE4J_JNI_BINDINGS_LIST = $(wildcard $(LOCAL_PATH)/src/main/cpp/*.cpp)

LOCAL_C_INCLUDES := $(OPENZWAVE_DIR)/cpp/src \
                    $(OPENZWAVE_DIR)/cpp/tinyxml \
                    $(LOCAL_PATH)/build/jni_include

LOCAL_MODULE := openzwave
LOCAL_SRC_FILES := $(OZW_MAIN_LIST:$(LOCAL_PATH)/%=%)
LOCAL_SRC_FILES += $(OZW_TINYXML_LIST:$(LOCAL_PATH)/%=%)
LOCAL_SRC_FILES += $(ZWAVE4J_JNI_BINDINGS_LIST:$(LOCAL_PATH)/%=%)

include $(BUILD_SHARED_LIBRARY)
