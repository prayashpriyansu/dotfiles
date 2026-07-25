#!/usr/bin/env bash
# Minimal Bluetooth picker (bluetoothctl + rofi)
theme="$HOME/.config/rofi/gruvbox.rasi"
menu() { rofi -dmenu -i -p "Bluetooth" -theme "$theme"; }

powered="$(bluetoothctl show | awk '/Powered:/ {print $2}')"
if [ "$powered" != "yes" ]; then
    [ "$(printf '󰂯  Power On' | menu)" = "󰂯  Power On" ] && bluetoothctl power on
    exit 0
fi

# Kick off a background scan so nearby devices show up
bluetoothctl --timeout 5 scan on >/dev/null 2>&1 &

devices="$(bluetoothctl devices | while read -r _ mac name; do
    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        printf '󰂱  %s\t%s\n' "$name" "$mac"
    else
        printf '   %s\t%s\n' "$name" "$mac"
    fi
done)"

chosen="$(printf '󰂲  Power Off\n󰑐  Rescan\n%s' "$devices" | menu)"
[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Power Off") bluetoothctl power off; exit 0 ;;
    *"Rescan")    exec "$0" ;;
esac

mac="$(printf '%s' "$chosen" | awk -F'\t' '{print $2}')"
[ -z "$mac" ] && exit 0

if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$mac"
else
    bluetoothctl connect "$mac" || { bluetoothctl pair "$mac" && bluetoothctl connect "$mac"; }
fi
