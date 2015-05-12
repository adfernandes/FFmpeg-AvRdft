NDK_TOOLCHAIN_VERSION := 4.9

APP_ABI      := armeabi-v7a x86 arm64-v8a x86_64
APP_PLATFORM := android-17 # 21 for 64-bit ABIs

APP_CFLAGS += -Wall
APP_CFLAGS += -fvisibility=hidden
