echo -1 | sudo tee /sys/bus/usb/devices/1-7/power/autosuspend
echo on | sudo tee /sys/bus/usb/devices/1-7/power/control
