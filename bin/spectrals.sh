#!/usr/bin/env bash

set -e

mkdir -p Spectrograms
for file in "$@"; do
    echo "Creating spectrogram for $file..."
    sox "$file" -n remix 1 spectrogram -x 3000 -y 513 -z 120 -w Kaiser -o "Spectrograms/$file-full.png"
    sox "$file" -n remix 1 spectrogram -x 500 -y 1025 -z 120 -w Kaiser -S 1:00 -d 0:02 -o "Spectrograms/$file-zoom.png"
done
echo "Done"