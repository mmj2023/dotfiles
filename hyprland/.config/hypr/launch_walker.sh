#!/usr/bin/env dash

gdbus call --session  --dest dev.benz.walker  --object-path /dev/benz/walker  --method org.gtk.Application.Activate  "{}"
# if a Walker window is active, close just the window
# if hyprctl clients | grep -q "class:Walker"; then
#   hyprctl dispatch closewindow class:Walker
# else
#   # otherwise, trigger the service to show the window
#   walker
# fi
# SERVICE="dev.benz.walker"
# OBJ_PATH="/dev/benz/walker"

# 1) Ensure the service is running (only registers the bus name once)
# if ! busctl --user | grep -qx "${SERVICE}"; then
#   walker --gapplication-service &
#   exit
# fi
# if ! busctl --user | grep -i walker; then
#   walker --gapplication-service &
#   exit
# fi

# 2) If Walker is already visible, hide via scratchpad
# if hyprctl clients | grep -q 'layer:overlay.*Walker'; then
#   hyprctl dispatch togglescratchpad
#   exit
# fi

# 3) Otherwise, show it with the proper D-Bus call
# gdbus call \
#   --session \
#   --dest "${SERVICE}" \
#   --object-path "${OBJ_PATH}" \
#   --method org.gtk.Application.Activate \
#   "{}"
gdbus call --session  --dest dev.benz.walker  --object-path /dev/benz/walker  --method org.gtk.Application.Activate  "{}"
