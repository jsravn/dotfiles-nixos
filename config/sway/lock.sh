#!/usr/bin/env bash

if grim ~/.cache/screen_locked.png; then
    mogrify -scale 5% -scale 2000% ~/.cache/screen_locked.png
fi
exec swaylock -f -i ~/.cache/screen_locked.png
