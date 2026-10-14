#!/bin/sh

sock="${XDG_RUNTIME_DIR:-/tmp}/wob.sock"

osd() {
    [ -S "$sock" ] || return 0
    printf '%s\n' "$1" > "$sock" 2>/dev/null
}

sink_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o '[0-9]\+%' | head -1 | tr -d '%'
}

case "$1" in
    vol-up)     pactl set-sink-mute @DEFAULT_SINK@ 0; pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    vol-down)   pactl set-sink-mute @DEFAULT_SINK@ 0; pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    vol-mute)   pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    mic-mute)   pactl set-source-mute @DEFAULT_SOURCE@ toggle; exit 0 ;;
    bright-up)  brightnessctl set 5%+ >/dev/null 2>&1 ;;
    bright-down) brightnessctl set 5%- >/dev/null 2>&1 ;;
    *) exit 1 ;;
esac

case "$1" in
    vol-*)
        if pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -q yes; then
            osd 0
        else
            vol=$(sink_volume)
            [ -n "$vol" ] && osd "$vol"
        fi
        ;;
    bright-*)
        cur=$(brightnessctl get 2>/dev/null)
        max=$(brightnessctl max 2>/dev/null)
        [ -n "$cur" ] && [ -n "$max" ] && [ "$max" -gt 0 ] && osd "$((cur * 100 / max))"
        ;;
esac
