#!/usr/bin/env bash
# Manually override hyprsunset for the rest of the current profile period.
FLAG="${XDG_RUNTIME_DIR:-/tmp}/hyprsunset-disabled"

if [ -f "$FLAG" ]; then
    hyprctl hyprsunset reset
    rm -f "$FLAG"
    notify-send "Night light" "Enabled"
else
    hyprctl hyprsunset identity
    touch "$FLAG"
    notify-send "Night light" "Disabled until next profile change"
fi
