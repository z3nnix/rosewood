#!/bin/sh

now_playing() {
    command -v playerctl >/dev/null 2>&1 || return
    timeout 1 playerctl status >/dev/null 2>&1 || return
    artist=$(timeout 1 playerctl metadata artist 2>/dev/null)
    title=$(timeout 1 playerctl metadata title 2>/dev/null)
    [ -z "$title" ] && return
    if [ -n "$artist" ]; then
        printf 'playing: %s - %s' "$artist" "$title"
    else
        printf 'playing: %s' "$title"
    fi
}

volume() {
    return
}

brightness() {
    command -v brightnessctl >/dev/null 2>&1 || return
    [ -n "$(ls /sys/class/backlight 2>/dev/null)" ] || return
    b=$(brightnessctl get 2>/dev/null) || return
    m=$(brightnessctl max 2>/dev/null) || return
    [ -n "$b" ] && [ -n "$m" ] && [ "$m" -gt 0 ] || return
    printf 'brt: %s%%' "$((b * 100 / m))"
}

network() {
    return
}

bluetooth() {
    command -v bluetoothctl >/dev/null 2>&1 || return
    for dev in /sys/class/bluetooth/hci*; do
        [ -e "$dev" ] || return
    done
    name=$(timeout 1 bluetoothctl info 2>/dev/null | awk -F': ' '/Name:/{print $2; exit}')
    [ -n "$name" ] && printf 'bt: %s' "$name"
}

battery() {
    for bat in /sys/class/power_supply/BAT*; do
        [ -e "$bat/capacity" ] || continue
        printf 'bat: %s%%' "$(cat "$bat/capacity")"
        return
    done
}

status_line() {
    out=""
    for fn in now_playing bluetooth battery; do
        val=$($fn)
        [ -n "$val" ] && out="${out}${out:+  |  }$val"
    done
    [ -n "$out" ] && out="$out  |  "
    printf '%s%s\n' "$out" "$(date +'%a %H:%M')"
}

while :; do
    ( status_line )
    sleep 1
done
