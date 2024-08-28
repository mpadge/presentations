#!/bin/bash

# Loop over all .txt files in the current directory
for f in *.tiff; do
    # Check if the file exists and is readable
    if [ -r "$f" ]; then
        base=$(basename "$f" .tiff)
        new_name="${base,,}.png"
        magick convert "$f" -transparent white "$new_name"
        echo "Converted $new_name"
    else
        echo "Error: Unable to read $f"
    fi
done

