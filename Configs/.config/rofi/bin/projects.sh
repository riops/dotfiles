#!/bin/bash

INDEX_FILE="$HOME/.index/projects.txt"


if [ -n "$1" ]; then
    CHOSEN_DIRECTORY=$(grep "/$1$" "$INDEX_FILE" | head -n1)
    kitty --directory="$CHOSEN_DIRECTORY"&
    killall rofi
else
# Display only dirnames in rofi and capture the selected one
CHOSEN_DIRNAME=$(awk -F/ '{print $NF}' "$INDEX_FILE")

echo "$CHOSEN_DIRNAME"
fi

