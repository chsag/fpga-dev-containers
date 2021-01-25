#!/bin/sh

script=$1
shift
arguments=$@

docker run --rm --interactive --tty \
    --volume "${PWD}:/work" \
    --volume "${QUARTUS_ROOTDIR}:/quartus" \
    --workdir "/work" \
    ghdl/vunit:gcc \
    "python3" \
    "/work/scripts/scripts/$script.py" \
    $arguments
