#!/usr/bin/env bash

EXPIRY=3000
NOTIFY_FILE=${XDG_CACHE_HOME}/volume-notify

notify-volume() {
    level=$(pamixer --get-volume)
    if (( $level > 100 )); then
        icon=audio-volume-overamplified-symbolic
    elif (( $level > 75 )); then
        icon=audio-volume-high-symbolic
    elif (( $level > 50 )); then
        icon=audio-volume-medium-symbolic
    else
        icon=audio-volume-low-symbolic
    fi
    notify-send.sh -R $NOTIFY_FILE -t $EXPIRY -i $icon -h int:value:$level -h string:synchronous:volume "Volume ${level}%"
}

case "$1" in

    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        if [[ "$(pamixer --get-mute)" == "true" ]]; then
            notify-send.sh -R $NOTIFY_FILE -t $EXPIRY -i audio-volume-muted 'Muted'
        else
            notify-send.sh -R $NOTIFY_FILE -t $EXPIRY -i audio-volume-high 'Unmuted'
        fi
        ;;

    raiseVolume)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        notify-volume
        ;;

    lowerVolume)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        notify-volume
        ;;

    *)
        echo "audio.sh: unknown command $1"
        exit 1
        ;;
esac
