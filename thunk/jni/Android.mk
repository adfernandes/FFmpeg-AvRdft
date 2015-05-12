LOCAL_PATH := $(call my-dir)
# ---------------------------------------------------------------------

MY_FFMPEG := FFmpeg/$(TARGET_ABI)

# ---------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE    :=                     avutil
LOCAL_SRC_FILES := $(MY_FFMPEG)/lib/libavutil.a

include $(PREBUILT_STATIC_LIBRARY)

# ---------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE    :=                     avcodec
LOCAL_SRC_FILES := $(MY_FFMPEG)/lib/libavcodec.a

include $(PREBUILT_STATIC_LIBRARY)

# ---------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE    := ThunkFFmpeg
LOCAL_SRC_FILES := thunk.c

LOCAL_SHARED_LIBRARIES := avcodec avutil

LOCAL_LDFLAGS := -Wl,--version-script=thunk.map

include $(BUILD_SHARED_LIBRARY)

