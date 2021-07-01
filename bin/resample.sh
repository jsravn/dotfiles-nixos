#!/usr/bin/env bash
set -eu

RATE=${RATE:-48000}

for flac in "$@"; do
    echo "Resampling $flac"
    set -x
    sox "$flac" -G -b 16 "2-$flac" rate -v -L $RATE dither
    set +x
    mv -f "2-$flac" "$flac"
done