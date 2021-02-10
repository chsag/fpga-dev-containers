#!/bin/sh

script=$1
shift
arguments=$@

docker run --rm --interactive --tty \
    --volume "${PWD}:/work" \
    --workdir "/work" \
    chsag/vhdl-scripts \
    python3 \
    "/work/scripts/scripts/$script.py" \
    $arguments
