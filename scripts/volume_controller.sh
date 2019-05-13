#!/bin/bash

# Requires Dunst
# Arbitrary but unique message id
msgId="991049"

if [ "$1" == + ]; then
    amixer -D pulse sset Master unmute 1%+
elif [ "$1" == - ]; then
    amixer -D pulse sset Master unmute 1%-
elif [ "$1" == "toggle" ]; then
    amixer -D pulse sset Master toggle
fi

volume="$(amixer -D pulse sget Master | grep -E -o -m 1 "[0-9]+%" | 
    cut -d % -f 1
    )"

speaker_status="$(amixer -D pulse sget Master | grep -E -o -m 1 "\[(on|off)\]")"

icon="🔊"
if [ $volume -lt 67 ]; then
    icon="🔉"
fi
if [ $volume -lt 34 ]; then
    icon="🔈"
fi
if [ "$speaker_status" == "[off]" ]; then
    icon="🔇"
fi

dunstify -a "volume_controller" -u low -i "audio-volume-high" -r "$msgId" \
    "$icon Volume: ${volume}%"
