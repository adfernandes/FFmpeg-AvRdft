#!/bin/bash

set -e

ARCHIVE="ffmpeg-2.6.3"
DESTROOT="${HOME}/Development/FFmpeg/destroot"

for BITS in 32 64 ; do

    rm -rf "${ARCHIVE}"
    tar xf "tar/${ARCHIVE}.tar.bz2"

    pushd "${ARCHIVE}" ; ( set -e

        patch -p1 < ../patch/linux-unversioned-soname.diff

        echo ""
        echo "--- CONFIGURATION LOG ---"
        echo ""

        ./configure \
            --disable-gpl --disable-version3 --disable-nonfree \
            --enable-static --disable-shared --enable-pic \
            --disable-small --enable-runtime-cpudetect \
            --disable-debug --enable-stripping \
            --disable-all --disable-pthreads --disable-w32threads \
            --enable-avutil --enable-avcodec \
            --enable-fft --enable-rdft --enable-hardcoded-tables \
            --enable-asm --enable-inline-asm \
            --extra-cflags=-m${BITS} --extra-ldflags=-m${BITS} \
            --arch=x86_${BITS} "--prefix=${DESTROOT}/linux${BITS}"

        echo ""
        echo "--- BUILD LOG ---"
        echo ""

        make V=1
        make V=1 install

        for LIB in ${DESTROOT}/linux${BITS}/lib/*.a ; do
            echo ANONYMIZE "${LIB}"
            LANG=C LC_CTYPE=C sed -i -e 's@/andrew/@/------/@g' "${LIB}"
        done

        rm -rfv "${DESTROOT}/linux${BITS}/lib/pkgconfig"

    ) ; popd

    rm -rf  "${ARCHIVE}"

done
