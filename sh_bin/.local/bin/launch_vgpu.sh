#!/usr/bin/env bash
export SUDO_ASKPASS=/usr/bin/ksshaskpass

# enable the virtual igpu if it is not already active
if [ "$(cat /sys/bus/pci/devices/0000:00:02.0/sriov_numvfs 2>/dev/null)" != "1" ]; then
    echo "enabling virtual igpu"
    echo 1 | sudo -A tee /sys/bus/pci/devices/0000:00:02.0/sriov_numvfs
fi

# start the win11-2 vm if it is not already running
if [ "$(virsh -c qemu:///system domstate win11-2 2>/dev/null)" != "running" ]; then
    echo "starting win11-2"
    virsh -c qemu:///system start win11-2
fi

# wait for the looking-glass shared memory to appear
until [ -e /dev/shm/looking-glass ]; do
    sleep 1
done

# give ownership of the looking-glass shared memory to the kvm group
sudo -A chown "$USER:kvm" /dev/shm/looking-glass
sudo -A chmod 0660 /dev/shm/looking-glass

# launch looking glass
~/Projects/LookingGlass/client/build/looking-glass-client -m KEY_RIGHTCTRL -f /dev/shm/looking-glass &
disown
