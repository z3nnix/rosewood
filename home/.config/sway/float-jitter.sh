#!/bin/sh

SIZE_PCT=50
JITTER=100

rand_jitter() {
    n=$(od -An -N2 -tu2 /dev/urandom | tr -d ' ')
    echo $(( n % (2 * JITTER + 1) - JITTER ))
}

geometry() {
    swaymsg -t get_outputs 2>/dev/null | jq -r '
        ([.[] | select(.focused == true)] | .[0]) // .[0]
        | "\(.rect.width) \(.rect.height) \(.rect.x) \(.rect.y)"'
}

swaymsg -t subscribe -m '["window"]' 2>/dev/null | while read -r event; do
    [ "$(printf '%s' "$event" | jq -r '.change // empty')" = "new" ] || continue

    id=$(printf '%s' "$event" | jq -r '.container.id // empty')
    appid=$(printf '%s' "$event" | jq -r '.container.app_id // empty')
    class=$(printf '%s' "$event" | jq -r '.container.window_properties.class // empty')
    role=$(printf '%s' "$event" | jq -r '.container.window_properties.window_role // empty')

    [ -n "$id" ] || continue

    [ "$appid" = "firefox" ] && continue
    [ "$class" = "firefox" ] && continue

    case "$role" in
        pop-up|task_dialog) continue ;;
    esac

    set -- $(geometry)
    sw=$1; sh=$2; ox=$3; oy=$4
    case "$sw" in ''|*[!0-9]*) continue ;; esac

    ww=$(( sw * SIZE_PCT / 100 ))
    wh=$(( sh * SIZE_PCT / 100 ))
    px=$(( ox + (sw - ww) / 2 + $(rand_jitter) ))
    py=$(( oy + (sh - wh) / 2 + $(rand_jitter) ))

    [ "$px" -lt "$ox" ] && px=$ox
    [ "$py" -lt "$oy" ] && py=$oy
    [ $(( px + ww )) -gt $(( ox + sw )) ] && px=$(( ox + sw - ww ))
    [ $(( py + wh )) -gt $(( oy + sh )) ] && py=$(( oy + sh - wh ))

    swaymsg "[con_id=$id] floating enable" >/dev/null 2>&1
    swaymsg "[con_id=$id] resize set $ww $wh" >/dev/null 2>&1
    swaymsg "[con_id=$id] move position $px $py" >/dev/null 2>&1
done
