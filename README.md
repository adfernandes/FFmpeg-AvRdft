# Rationale

Sometimes you just need a fast, real, single-precision, [discrete fast Fourier transform](http://en.wikipedia.org/wiki/Fast_Fourier_transform) (RDFFT, or FFT for short).

But it needs to be cross-platform. Yech.

And for [Android](https://developer.android.com/tools/sdk/ndk/index.html). Double-yech.

And Windows. Which you don't have, since you develop on Linux.

Sigh.

What to do?

Well... [FFmpeg](https://www.ffmpeg.org/) is well-known to have very fast, hand-tuned assembly routines for transform lengths up to 65536. Maybe we can use that?

And build it as a shared library so it's easy to comply with its license.

On all those platforms.

Oh boy.

What to do?

You use this collection of build scripts, of course!

(Or, just use the binaries herein. They are tested and ready to use!)

# Building

If you want to tweak or modify, we assume the following:

* The build-host is 64-bit Ubuntu 14.10, with the latest compiler for that distro.
* A Windows toolchain was installed from [Zeranoe](http://ffmpeg.zeranoe.com/blog/?cat=4
). Both the 32-bit and 64-bit are required. We used `mingw-w64-build-3.6.6` with the following configuration:
```
./mingw-w64-build \
      --build-type=multi \
      --default-configure \
      --disable-shared \
      --enable-gendef --enable-widl \
      --gcc-langs=c,c++,fortran,lto \
      --clean-build
```
* The [Android NDK](https://developer.android.com/tools/sdk/ndk/index.html), version `10e`.

As configured in the top-level `build*` shell scripts, `build.sh` runs each of the `build-*.sh` scripts. They build static libraries for `libavcodec.a` and `libavutil.a` for the following platforms:

* `android-17-armeabi-v7a` and `android-17-x86`
* `android-21-arm64-v8a` and `android-21-x86_64`
* `windows32` and `windows64`
* `linux32` and `linux64`

# Using

You can use the static libraries as-is, but be aware that by statically linking, the rest of your code must be compatible with the [LGPL-2.1+](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html). See the [license](LICENSE.md) file for explicit details.

If you cannot be `LGPL-2.1+` compatible, you must use `FFmpeg` and its routines through a shared library.

Thus the next part of our build scripts create `libThunkFFmpeg.so` for all platforms, which is a library that contains **only** the `rdft` routines and support data.

Thus it is as small as we can get, including no unnecessary cruft.

If a vectorized code path for the transform is selected at runtime, the RDFT routines can segfault if the input and output are not properly aligned. This was tested on a `linux64` benchmarking build. By default, all symbols are private except the necessary interface functions and support data.

Alignment must be 8-byte for `NEON`, 16-byte for `SSE`, and 32-byte for `AVX` and `AVX2`.

# Notes

The resulting RDFT wrapper `libThunkFFmpeg.so` library exposes **only** the RDFT functions from `FFmpeg`. Why? By default, FFmpeg requires two libraries `libavcodec` and `libavutil`, both of which have public visibility for all symbols.

This gives all sorts of warnings about security and memory-wasteage on Android. For some reason,
the way that the libraries are built, the Android runtime linker gives
```
WARNING: linker: libavcodec.so has text relocations. This is wasting memory and is a security risk. Please fix.
```
upon loading the shared object. By hiding all unnecssary symbols, we get rid of all these problems. (Well, at least theoretically. The wrapper `libThunkFFmpeg.so` still gives the same warning. Sigh. But at least all the unused parts of the library are hidden from external linkage...)

## 64-Bit Linux Hack

The `libThunkFFmpeg.so` wrapper library on 64-bit Linux behaves oddly since the FFmpeg libraries have `R_X86_64_PC32` relocations for the `ff_cos_{number}` symbols [no matter how they are built](http://eli.thegreenplace.net/2011/11/11/position-independent-code-pic-in-shared-libraries-on-x64/). These relocations prevent the static libraries from being used in shared objects.

To solve that problem, I simply reproduce the tables as required (for 64-bit Linux **only**), and tell the linker to not complain about multiply-defined symbols, using mine preferentially. Note that I'm very careful to reproduce the tables _exactly_ the way that FFmpeg does, including alignment and the "table of tables" table!

## On Apple Platforms

Also note that none of this applies to iOS or MacOS, as we can use the built-in `Accelerate` framework rather than `FFmpeg`. That gets over the licensing issues too, since `iOS` does not support shared libraries for user applications.
