#!/bin/bash
setxkbmap -layout "us,ru" # Установит раскладки us и ru
setxkbmap -option "grp:caps_toggle,grp_led:scroll,ctrl:nocaps"
xsetroot -cursor_name left_ptr &
export PATH=~/bin:$PATH
exec xmonad
