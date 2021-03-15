#!/usr/bin/env bash
set -eu

if [ $# -lt 1 ]; then
    echo "$0 <flac"
    exit 1
fi

flac="$1"
rate="${2:-48000}"

sox "$flac" -G -b 16 "2-$flac" rate -v -L $rate dither
mv -f "2-$flac" "$flac"