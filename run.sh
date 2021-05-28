#!/bin/sh

script=$1
shift
arguments=$@

docker run --rm --tty \
    --volume "${PWD}:/work" \
    --workdir "/work" \
    chsag/vhdl-scripts:0.3 \
    python3 \
    "/work/scripts/scripts/$script.py" \
    $arguments
