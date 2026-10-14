#!/bin/sh

theme="$HOME/.config/rofi/themes/rosewood.rasi"
render="${XDG_STATE_HOME:-$HOME/.local/state}/rosewood/render.json"
lockbg=$(jq -r '.rw.ui.bg_soft // "#1A1418"' "$render" 2>/dev/null)
lockbg=${lockbg#\#}

chosen=$(printf '%s\n' Lock Logout Suspend Reboot Poweroff \
    | rofi -dmenu -i -p power -theme "$theme")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    Lock)     swaylock -f -c "$lockbg" ;;
    Logout)   swaymsg exit ;;
    Suspend)  swaylock -f -c "$lockbg" && loginctl suspend ;;
    Reboot)   loginctl reboot ;;
    Poweroff) loginctl poweroff ;;
esac
