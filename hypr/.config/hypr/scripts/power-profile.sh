#!/usr/bin/env bash
# Cycle power-profiles-daemon profile: performance -> balanced -> power-saver
current="$(powerprofilesctl get)"

case "$current" in
    performance) next="balanced" ;;
    balanced)    next="power-saver" ;;
    power-saver) next="performance" ;;
    *)           next="balanced" ;;
esac

powerprofilesctl set "$next"
notify-send "Power profile" "$next"
