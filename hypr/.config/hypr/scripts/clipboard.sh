#!/usr/bin/env bash
# Clipboard history picker (cliphist + rofi)
theme="$HOME/.config/rofi/gruvbox.rasi"

sel="$(cliphist list | rofi -dmenu -i -p "Clipboard" -theme "$theme")"
[ -z "$sel" ] && exit 0
printf '%s' "$sel" | cliphist decode | wl-copy
