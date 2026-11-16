#!/bin/sh

theme="$HOME/.config/rofi/themes/rosewood.rasi"

chosen=$(printf '%s\n' Logout Suspend Reboot Poweroff \
    | rofi -dmenu -i -p power -theme "$theme")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    Logout)   swaymsg exit ;;
    Suspend)  loginctl suspend ;;
    Reboot)   loginctl reboot ;;
    Poweroff) loginctl poweroff ;;
esac
