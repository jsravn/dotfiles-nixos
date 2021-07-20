#!/usr/bin/env bash

echo "making webcam awesome again"
nix run nixos.v4l-utils -c v4l2-ctl -d /dev/video0 --set-ctrl=exposure_auto=1
nix run nixos.v4l-utils -c v4l2-ctl -d /dev/video0 --set-ctrl=focus_auto=0
nix run nixos.v4l-utils -c v4l2-ctl -d /dev/video0 --list-ctrls
echo "done!"