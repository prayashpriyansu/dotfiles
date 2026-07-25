#!/usr/bin/env bash
# Minimal Wi-Fi picker (nmcli + rofi)
theme="$HOME/.config/rofi/gruvbox.rasi"
menu() { rofi -dmenu -i -p "Wi-Fi" -theme "$theme"; }

if [ "$(nmcli -g WIFI radio 2>/dev/null)" = "disabled" ]; then
    toggle="󰖩  Enable Wi-Fi"
else
    toggle="󰖪  Disable Wi-Fi"
fi

# SSID  (signal%), strongest first, de-duplicated
list="$(nmcli --terse --fields SSID,SIGNAL device wifi list 2>/dev/null \
    | awk -F: '$1!="" {printf "%s\t%s\n", $1, $2}' \
    | sort -t$'\t' -k2 -rn \
    | awk -F'\t' '!seen[$1]++ {printf "%s  (%s%%)\n", $1, $2}')"

chosen="$(printf '%s\n%s' "$toggle" "$list" | menu)"
[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Enable Wi-Fi")  nmcli radio wifi on;  exit 0 ;;
    *"Disable Wi-Fi") nmcli radio wifi off; exit 0 ;;
esac

ssid="${chosen%%  (*}"
[ -z "$ssid" ] && exit 0

if nmcli -g NAME connection show | grep -qxF "$ssid"; then
    nmcli connection up id "$ssid"
else
    pass="$(printf '' | rofi -dmenu -password -p "Password for $ssid" -theme "$theme")"
    if [ -n "$pass" ]; then
        nmcli device wifi connect "$ssid" password "$pass"
    else
        nmcli device wifi connect "$ssid"
    fi
fi
