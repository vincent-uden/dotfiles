#!/bin/sh

# Requires my backlight.py script (github.com/vincent-uden/dotfiles)

# Arbitrary but unique message id
msgId="991048"

icon="🔆"
if [ "$1" == + ]; then
    sudo python ~/github/dotfiles/scripts/backlight.py -i 5
elif [ "$1" == - ]; then
    sudo python ~/github/dotfiles/scripts/backlight.py -i -5
    icon="🔅"
fi

max_bright=255
brightness="$(sudo python ~/github/dotfiles/scripts/backlight.py -s)"
percent="$(echo "print(round($brightness * 100 / $max_bright))" | python)"

dunstify -a "brightness_controller" -u low -r "$msgId" \
    "$icon Brightness: ${percent}%"

