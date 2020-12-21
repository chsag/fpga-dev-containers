docker run --rm --interactive --tty `
    --volume "${PWD}:/work" `
    --workdir "/work" `
    ghdl/vunit:gcc `
    "sh" `
    "/work/scripts/$args.sh"
