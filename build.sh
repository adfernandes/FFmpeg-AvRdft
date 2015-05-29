#!/bin/bash

set -ex
exec 2>&1

LOG=build.log
rm -rf "${LOG}.gz"
(
    set -ex
    exec 2>&1

    rm -rf destroot

    for i in android linux windows ; do
       echo "building ${i}"
       "./build-${i}.sh"
    done

    pushd thunk
        make clean
        make
        pushd test
            ./test.sh
        popd
    popd

) 2>&1 | tee "${LOG}"
gzip -9v  "${LOG}"
