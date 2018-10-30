LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

OPENZWAVE_DIR := $(LOCAL_PATH)/../../open-zwave

OZW_MAIN_LIST = $(wildcard $(OPENZWAVE_DIR)/cpp/src/*.cpp \
                           $(OPENZWAVE_DIR)/cpp/src/aes/*.cpp \
                           $(OPENZWAVE_DIR)/cpp/src/command_classes/*.cpp \
                           $(OPENZWAVE_DIR)/cpp/src/value_classes/*.cpp \
                           $(OPENZWAVE_DIR)/cpp/src/platform/*.cpp \
                           $(OPENZWAVE_DIR)/cpp/src/platform/unix/*.cpp)

OZW_TINYXML_LIST = $(wildcard $(OPENZWAVE_DIR)/cpp/tinyxml/*.cpp)

LOCAL_SRC_FILES := $(OZW_MAIN_LIST:$(LOCAL_PATH)/%=%)
LOCAL_SRC_FILES += $(OZW_TINYXML_LIST:$(LOCAL_PATH)/%=%)

LOCAL_MODULE := openzwave
LOCAL_SRC_FILES := $(JNI_SOURCES)

include $(BUILD_SHARED_LIBRARY)
