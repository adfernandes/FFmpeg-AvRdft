# Licensing

Licensing of this repository is just a tiny bit more complex than usual, since the libraries can be built in so many different ways and have so many different parts.

Almost everything here is licensed under the [GNU Lesser General Public License (LGPL), version 2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html) **or later** (abbreviated as `LGPL-2.1+`).

Specifically, the `FFmpeg` source code, all of the build scripts, and the binaries are licensed under the `LGPL-2.1+`. Note that care is taken to use _only_ `LGPL-2.1+` compatible options when building `FFmpeg`.

To ensure compliance, see the [online checklist](http://www.ffmpeg.org/legal.html).

A nice summary of LGPL complance is on [Stack Overflow](http://stackoverflow.com/a/10179181/1229371).

There also are exceptions in the `tools` directory, which just mirrors external tools that either are used or have been used developing this build. Please see the individual files and subdirectories there for specific licenses.
