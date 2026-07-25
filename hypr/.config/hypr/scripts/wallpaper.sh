#!/usr/bin/env bash
# Start the wallpaper daemon (if needed) and set the wallpaper.
# Change WALL to swap wallpapers — this is the single source of truth.
WALL="$HOME/Pictures/wallpapers/gruvbox-minimal.png"

if ! pgrep -x awww-daemon >/dev/null; then
    awww-daemon &
    sleep 0.5
fi

awww img "$WALL" \
    --transition-type grow \
    --transition-pos center \
    --transition-duration 1
