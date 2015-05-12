#!/bin/bash

echo "# FFmpeg"
g++ -DUSE_FFMPEG test.cpp -lavcodec -o test
./test
echo ""

echo "# linux32"
g++ -m32 test.cpp ../libs/linux32/libThunkFFmpeg.so -o test
LD_LIBRARY_PATH=../libs/linux32 ./test
echo ""

echo "# linux64"
g++ test.cpp ../libs/linux64/libThunkFFmpeg.so -o test
LD_LIBRARY_PATH=../libs/linux64 ./test
echo ""

rm test

