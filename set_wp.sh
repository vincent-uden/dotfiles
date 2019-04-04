#!/usr/bin/env bash

DOTFILE_PATH="/home/vincent/.config/i3/config"

if [[ -f $1 ]]; then
    IMG_PATH=$1
    feh --bg-scale $1
    sed -i -e "s@feh .*@feh --bg-scale $1@g" $DOTFILE_PATH
else
    echo "$1 Not found"
fi
