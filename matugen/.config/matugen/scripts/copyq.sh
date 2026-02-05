#!/usr/bin/env bash

sleep 0.1
copyq exit
sleep 0.1
copyq --start-server
sleep 0.1
copyq eval 'loadTheme("/home/mdmmj/.config/copyq/themes/mine.ini")'
copyq exit
sleep 0.1
copyq --start-server

# notify-send "CopyQ" "Themes reloaded"
