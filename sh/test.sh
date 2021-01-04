#! /bin/sh
for filename in /work/test/test_*.py; do
    python3 "$filename" --gtkwave-fmt vcd
done
