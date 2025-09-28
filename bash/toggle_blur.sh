#!/usr/bin/env bash

# Toggle blur

state=$(hyprctl getoption decoration:blur:enabled -j | jq -r '.int')

if [ $state -eq 1 ]; then
    hyprctl keyword decoration:blur:enabled false
else
    hyprctl keyword decoration:blur:enabled true
fi
