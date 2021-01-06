$script, $arguments = $args

docker run --rm --interactive --tty `
    --volume "${PWD}:/work" `
    --workdir "/work" `
    ghdl/vunit:gcc `
    "python3" `
    "/work/scripts/scripts/$script.py" `
    $arguments
