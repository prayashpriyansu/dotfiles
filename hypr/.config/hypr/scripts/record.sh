#!/usr/bin/env bash
# Screen recording toggle (wf-recorder). Video only, no audio by default.
DIR="$HOME/Videos/Recordings"
mkdir -p "$DIR"

if pgrep -x wf-recorder >/dev/null; then
    pkill -INT -x wf-recorder # SIGINT lets wf-recorder finalize the file cleanly
    notify-send "Recording stopped" "Saved to $DIR"
else
    file="$DIR/$(date +%Y-%m-%d_%H-%M-%S).mp4"
    notify-send "Recording started" "$file"
    wf-recorder -f "$file" &
    disown
fi
