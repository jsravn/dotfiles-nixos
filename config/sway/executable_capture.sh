#!/usr/bin/env bash

set -e

output=$1
grim -g "$(slurp)" $output
