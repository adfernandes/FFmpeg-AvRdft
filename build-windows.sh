#!/bin/bash

set -e

ARCHIVE="ffmpeg-2.6.3"
DESTROOT="${HOME}/Development/FFmpeg/destroot"
TLCHROOT="${HOME}/Development" # location of 'mingw{32,64}'
TLCHXTRA="${HOME}/Development/FFmpeg/tools/Windows"

for BITS in 32 64 ; do

    rm -rf "${ARCHIVE}"
    tar xf "tar/${ARCHIVE}.tar.bz2"

    pushd "${ARCHIVE}" ; ( set -e

        echo ""
        echo "--- CONFIGURATION LOG ---"
        echo ""

        TOOLCHAIN="${TLCHROOT}/mingw${BITS}"

        case "${BITS}" in
            32 )
                TCHPREFIX="i686-w64-mingw32"
                ;;
            64 )
                TCHPREFIX="x86_64-w64-mingw32"
                ;;
            *  )
                echo "error: unknown '${BITS}' bits"
                exit 1
                ;;
        esac

        export PATH="${TLCHXTRA}:${TLCHROOT}/mingw${BITS}/bin:${PATH}"

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
            "--prefix=${DESTROOT}/windows${BITS}" --arch=x86_${BITS} \
            "--cross-prefix=${TCHPREFIX}-" --target-os=win${BITS} \
            "--sysroot=${TOOLCHAIN}"

        echo ""
        echo "--- BUILD LOG ---"
        echo ""

        make V=1
        make V=1 install

        for LIB in ${DESTROOT}/windows${BITS}/lib/*.a ; do
            echo ANONYMIZE "${LIB}"
            LANG=C LC_CTYPE=C sed -i -e 's@/andrew/@/------/@g' "${LIB}"
        done

    	rm -rfv "${DESTROOT}/windows${BITS}/lib/pkgconfig"

    ) ; popd

    rm -rf  "${ARCHIVE}"

done
