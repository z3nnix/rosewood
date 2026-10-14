#!/bin/sh

theme="$HOME/.local/share/rofi/themes/amoled.rasi"

chosen=$(printf '%s\n' Lock Logout Suspend Reboot Poweroff \
    | rofi -dmenu -i -p power -theme "$theme")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    Lock)     swaylock -f -c 1A1418 ;;
    Logout)   swaymsg exit ;;
    Suspend)  swaylock -f -c 1A1418 && loginctl suspend ;;
    Reboot)   loginctl reboot ;;
    Poweroff) loginctl poweroff ;;
esac
