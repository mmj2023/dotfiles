#!/usr/bin/env bash

CONFIG="$HOME/.config/wayscriber/config.toml"

python3 - "$CONFIG" <<'PY'
import re, sys

path = sys.argv[1]
with open(path) as f:
    text = f.read()

def conv(m):
    r, g, b = int(m[1]), int(m[2]), int(m[3])
    a = m[4]
    return f"[{r/255:.3f}, {g/255:.3f}, {b/255:.3f}, {a}]"

text = re.sub(r'\[\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d*\.?\d+)\s*,?\s*\]', conv, text)
with open(path, "w") as f:
    f.write(text)
PY

if pgrep -x wayscriber >/dev/null 2>&1; then
    pkill -x wayscriber
    sleep 0.2
    nohup wayscriber --daemon >/dev/null 2>&1 &
fi
