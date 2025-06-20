!/usr/bin/env bash

# This script is used to launch applications in rofi
# Kill any active rofi instance
pkill rofi

# Prompt the user for input using rofi (you can adjust the prompt text)
user_input=$(rofi -dmenu -p "Launch:")

# Exit if nothing was entered
[ -z "$user_input" ] && exit 0

# Check if input starts with "!"
if [[ "$user_input" == "!"* ]]; then
    # Remove the leading "!" and trim any whitespace
    query=$(echo "${user_input:1}" | xargs)
    # Replace spaces with '+' for a simple URL-encoding
    encoded_query=$(echo "$query" | sed 's/ /+/g')
    # Build the DuckDuckGo search URL (you can change the search engine URL if needed)
    search_url="https://duckduckgo.com/?q=${encoded_query}"
    # Open the default web browser with the search URL
    xdg-open "$search_url"
else
    # Otherwise, launch the standard drun mode of rofi
    rofi -show drun
fi
