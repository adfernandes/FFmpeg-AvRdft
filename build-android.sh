#!/bin/bash

set -e

ARCHIVE="ffmpeg-2.6.3"
DESTROOT="${HOME}/Development/FFmpeg/destroot"
ANDKROOT="${HOME}/Development/android-ndk-r10e" # r10e integrates 'fix-cortex-a53-835769'
PREBUILT="linux-x86_64"

# See "${ANDKROOT}/docs/CPU-ARCH-ABIS.html"
# and "${ANDKROOT}/toolchains/*/setup.mk"

for ABI in armeabi-v7a x86 arm64-v8a x86_64 ; do

    rm -rf "${ARCHIVE}"
    tar xf "tar/${ARCHIVE}.tar.bz2"

    pushd "${ARCHIVE}" ; ( set -e

        patch -p1 < ../patch/linux-unversioned-soname.diff

        echo ""
        echo "--- CONFIGURATION LOG ---"
        echo ""

        TARGET_COMMON_CFLAGS="-ffunction-sections -funwind-tables -no-canonical-prefixes"
        TARGET_COMMON_LDFLAGS="-no-canonical-prefixes"

        case "${ABI}" in
            armeabi-v7a )
                ARCH="arm"
                TCHPREFIX="${ARCH}-linux-androideabi"
                TOOLCHAIN="${TCHPREFIX}-4.9" # NOTE: NEON is detected at RUNTIME
                TARGET_CFLAGS="${TARGET_COMMON_CFLAGS} -fpic -march=armv7-a -mthumb -mfloat-abi=softfp -mfpu=vfpv3-d16"
                TARGET_LDFLAGS="${TARGET_COMMON_LDFLAGS} -march=armv7-a -Wl,--fix-cortex-a8"
                PLATFORM="android-17"
                ;;
            arm64-v8a )
                ARCH="arm64"
                TCHPREFIX="aarch64-linux-android"
                TOOLCHAIN="${TCHPREFIX}-4.9" # NOTE: NEON is detected at RUNTIME
                TARGET_CFLAGS="${TARGET_COMMON_CFLAGS} -fpic"
                TARGET_LDFLAGS="${TARGET_COMMON_LDFLAGS}"
                PLATFORM="android-21"
                ;;
            x86 )
                ARCH="x86"
                TCHPREFIX="i686-linux-android"
                TOOLCHAIN="${ARCH}-4.9"
                TARGET_CFLAGS="${TARGET_COMMON_CFLAGS}"
                TARGET_LDFLAGS="${TARGET_COMMON_LDFLAGS}"
                PLATFORM="android-17"
                ;;
            x86_64 )
                ARCH="x86_64"
                TCHPREFIX="${ARCH}-linux-android"
                TOOLCHAIN="${ARCH}-4.9"
                TARGET_CFLAGS="${TARGET_COMMON_CFLAGS}"
                TARGET_LDFLAGS="${TARGET_COMMON_LDFLAGS}"
                PLATFORM="android-21"
                ;;
            *    )
                echo "error: unknown '${ARCH}' arch"
                exit 1
                ;;
        esac

        export PATH="${ANDKROOT}/toolchains/${TOOLCHAIN}/prebuilt/${PREBUILT}/bin:${PATH}"
        echo "PATH = ${PATH}"

        ./configure \
            --disable-gpl --disable-version3 --disable-nonfree \
            --enable-static --disable-shared --enable-pic \
            --disable-small --enable-runtime-cpudetect \
            --disable-debug --enable-stripping \
            --disable-all --disable-pthreads --disable-w32threads \
            --enable-avutil --enable-avcodec \
            --enable-fft --enable-rdft --enable-hardcoded-tables \
            --enable-asm --enable-inline-asm \
            --enable-cross-compile \
            "--prefix=${DESTROOT}/${PLATFORM}-${ABI}" "--arch=${ARCH}" \
            "--cross-prefix=${TCHPREFIX}-" --target-os=linux \
            "--sysroot=${ANDKROOT}/platforms/${PLATFORM}/arch-${ARCH}" \
            "--extra-cflags=${TARGET_CFLAGS}" "--extra-ldflags=${TARGET_LDFLAGS}"

        echo ""
        echo "--- BUILD LOG ---"
        echo ""

        make V=1
        make V=1 install

        for LIB in ${DESTROOT}/${PLATFORM}-${ABI}/lib/*.a ; do
            echo ANONYMIZE "${LIB}"
            LANG=C LC_CTYPE=C sed -i -e 's@/andrew/@/------/@g' "${LIB}"
        done

        rm -rfv "${DESTROOT}/${PLATFORM}-${ABI}/lib/pkgconfig"

    ) ; popd

    rm -rf  "${ARCHIVE}"

done
