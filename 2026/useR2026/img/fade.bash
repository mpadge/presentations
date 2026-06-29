#!/usr/bin/env bash
FILE=icon_lettering_color_large-faded.png
magick "$FILE" -channel alpha -evaluate multiply 0.5 +channel "$FILE"
