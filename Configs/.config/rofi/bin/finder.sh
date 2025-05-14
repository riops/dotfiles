#!/bin/sh

INDEX_FILE="$HOME/.index/indexed_files.txt"

# Recursive function to list all files
index_files() {
    local dir="$1"
    if [ -f "$dir" ]; then
        # Only index specified file extensions
        case "$dir" in
            *.pdf|*.py|*.djvu|*.cpp|*.jpg|*.png)
                echo "$dir" >> "$INDEX_FILE"
                ;;
        esac
    elif [ -d "$dir" ]; then
        for item in "$dir"/*; do
            index_files "$item"
        done
    fi
}

if [ "$1" = "index_all_again" ]; then
    > "$INDEX_FILE"  # Empty the current index
    index_files "$HOME/Dropbox/"
    echo "Indexing complete!"

elif [ "$1" = "Indexing complete!" ]; then
    CHOSEN_FILENAME=$(awk -F/ '{print $NF}' "$INDEX_FILE")
    echo "$CHOSEN_FILENAME"

# If a filename is provided, open its full path
elif [ -n "$1" ]; then
    CHOSEN_FILE=$(grep "/$1$" "$INDEX_FILE" | head -n1)
    xdg-open "$CHOSEN_FILE" &
    killall rofi

else
    # Display only filenames in rofi (or stdout) and capture the selected one
    CHOSEN_FILENAME=$(awk -F/ '{print $NF}' "$INDEX_FILE")
    echo "$CHOSEN_FILENAME"
fi
