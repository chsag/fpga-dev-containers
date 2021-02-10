#!/bin/sh

script=$1
shift
arguments=$@

docker run --rm --interactive --tty \
    --volume "${PWD}:/work" \
    --workdir "/work" \
    chsag/vhdl-scripts \
    "/work/scripts/scripts/$script" \
    $arguments
