#!/bin/bash
#   ____ _                              _____ _                          
#  / ___| |__   __ _ _ __   __ _  ___  |_   _| |__   ___ _ __ ___   ___  
# | |   | '_ \ / _` | '_ \ / _` |/ _ \   | | | '_ \ / _ \ '_ ` _ \ / _ \ 
# | |___| | | | (_| | | | | (_| |  __/   | | | | | |  __/ | | | | |  __/ 
#  \____|_| |_|\__,_|_| |_|\__, |\___|   |_| |_| |_|\___|_| |_| |_|\___| 
#                          |___/                                         

WALLPAPERS_DIR="$HOME/.wallpapers"

# If no arguments are passed, list the filenames
if [ -z "$1" ]; then
    for file in "$WALLPAPERS_DIR"/*; do
        basename "$file"
    done
else
    # If an argument is passed, assume it's a filename and execute the commands
    WALLPAPER="$1"
    swaybg -m fill -i "$WALLPAPERS_DIR/$WALLPAPER"&
    wal -i "$WALLPAPERS_DIR/$WALLPAPER"&

    # Restart waybar
    killall waybar
    waybar &
    zathura-pywal&
fi
