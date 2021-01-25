$script, $arguments = $args

docker run --rm --interactive --tty `
    --volume "${PWD}:/work" `
    --volume "${Env:QUARTUS_ROOTDIR}:/quartus" `
    --workdir "/work" `
    ghdl/vunit:gcc `
    "python3" `
    "/work/scripts/scripts/$script.py" `
    $arguments
