$script, $arguments = $args

docker run --rm --interactive --tty `
    --volume "${PWD}:/work" `
    --workdir "/work" `
    chsag/vhdl-scripts `
    "/work/scripts/scripts/$script" `
    $arguments
