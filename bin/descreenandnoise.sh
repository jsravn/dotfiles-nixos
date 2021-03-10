#!/usr/bin/env bash

descreenandnoise() {
    descreen.py "$1.png" "$1-descreened.png"
    waifu2x-converter-cpp -m noise --noise-level 1 -i "$1-descreened.png" -o "$1-final.png"
}

for f in $@; do
    echo Processing $f
    descreenandnoise "$(basename -s .png "$f")" &
done

wait
