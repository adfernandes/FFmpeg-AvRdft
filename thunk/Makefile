.PHONY : default linux32 linux64 windows32 windows64 android verify clean

ANDROID_NDK_HOME=$(HOME)/Development/android-ndk-r10d
ANDROID_NDK_API32=17
ANDROID_NDK_API64=21

LIN32GCC=/usr/bin/gcc -m32
LIN32LIB=-L../destroot/linux32/lib
LIN32DIR=libs/linux32

LIN64GCC=/usr/bin/gcc
LIN64LIB=-L../destroot/linux64/lib
LIN64DIR=libs/linux64

WIN32GCC=$(HOME)/Development/mingw32/bin/i686-w64-mingw32-gcc
WIN32LIB=-L../destroot/windows32/lib
WIN32GEN=$(HOME)/Development/mingw32/bin/gendef
WIN32DIR=libs/windows32

WIN64GCC=$(HOME)/Development/mingw64/bin/x86_64-w64-mingw32-gcc
WIN64LIB=-L../destroot/windows64/lib
WIN64GEN=$(HOME)/Development/mingw64/bin/gendef
WIN64DIR=libs/windows64

CFLAGS=-s -fvisibility=hidden -shared
LIBS=-lavcodec -lavutil

default : linux32 linux64 windows32 windows64 android verify

linux32 :
	mkdir -p $(LIN32DIR)
	$(LIN32GCC) $(CFLAGS) -fPIC thunk.c $(LIN32LIB) $(LIBS) -Wl,--version-script=thunk.map -Wl,-soname,libThunkFFmpeg.so -o $(LIN32DIR)/libThunkFFmpeg.so

linux64 :
	mkdir -p $(LIN64DIR)
	cd tables && $(MAKE)
	$(LIN64GCC) $(CFLAGS) -fPIC thunk.c -Itables tables/ff_cos.c $(LIN64LIB) $(LIBS) -Wl,--version-script=thunk.map -Wl,-soname,libThunkFFmpeg.so -Wl,--allow-multiple-definition -o $(LIN64DIR)/libThunkFFmpeg.so

windows32 :
	mkdir -p $(WIN32DIR)
	$(WIN32GCC) $(CFLAGS) thunk.c $(WIN32LIB) $(LIBS) -Wl,--out-implib,$(WIN32DIR)/libThunkFFmpeg.a -o $(WIN32DIR)/libThunkFFmpeg.dll
	$(WIN32GEN) - $(WIN32DIR)/libThunkFFmpeg.dll | sed '/^;/d; s/\(@[0-9]\)\1/\1/' > $(WIN32DIR)/libThunkFFmpeg.def

windows64 :
	mkdir -p $(WIN64DIR)
	$(WIN64GCC) $(CFLAGS) thunk.c $(WIN64LIB) $(LIBS) -o $(WIN64DIR)/libThunkFFmpeg.dll
	$(WIN64GEN) - $(WIN64DIR)/libThunkFFmpeg.dll | sed '/^;/d' > $(WIN64DIR)/libThunkFFmpeg.def

android :
	$(ANDROID_NDK_HOME)/ndk-build V=1
	for i in armeabi-v7a x86  ; do mv "libs/$${i}" "libs/android-$(ANDROID_NDK_API32)-$${i}"; done
	for i in arm64-v8a x86_64 ; do mv "libs/$${i}" "libs/android-$(ANDROID_NDK_API64)-$${i}"; done

verify :
	find libs -type f -print0 | xargs -0 /usr/bin/file

clean :
	rm -rf obj libs
	cd tables && $(MAKE) clean
