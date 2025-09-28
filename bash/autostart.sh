#!/usr/bin/env bash

wlr-randr --output eDP-1 --scale 1.25
hypridle & disown
copyq --start-server & disown
prime-run swww-daemon & disown
prime-run waybar & disown
elephant & disown
prime-run walker --gapplication-service & disown
