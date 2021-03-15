#!/usr/bin/env bash
set -eu

if [ $# -lt 1 ]; then
    echo "$0 <flac>"
    exit 1
fi

flac=$1

echo "Scrubbing $flac"
metaflac --export-tags-to=tags.txt "$flac"
metaflac --remove-all-tags "$flac"
metaflac --remove --block-type=PICTURE --dont-use-padding "$flac"
metaflac --dont-use-padding --remove --block-type=PADDING "$flac"

echo "Post-scrub flags"
metaflac --list "$flac"

echo
echo "Now edit tags.txt, then import them with:"
echo "metaflac --import-tags-from=tags.txt '$flac'"