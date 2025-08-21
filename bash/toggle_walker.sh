#!/bin/bash
# toggle-walker.sh
if hyprctl layers -j | jq -e '.[].levels[][] | select(.namespace | test("walker";"i"))' >/dev/null; then
   pkill walker
else
   walker   # launches normally
fi
nohup walker --gapplication-service >/dev/null 2>&1 &
# if ! pgrep -x walker >/dev/null; then
#    nohup walker --gapplication-service >/dev/null 2>&1 &
# fi
# hyprctl layers -j | jq -e '.[].levels[][] | select(.namespace|test("walker";"i"))' >/dev/null && pkill walker || nohup walker --gapplication-service >/dev/null 2>&1 &
