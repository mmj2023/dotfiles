#!/usr/bin/env bash
# check what gpu driver is loaded
lsmod | grep -i i915
lspci -k -s 00:02.0
# get input on how many virtual igpus to set
read -p "How many virtual igpus do you want to set? [1-7] " VIRTUAL_GPU
VIRTUAL_GPU=${VIRTUAL_GPU:-1}
# set_virtual_igpus_intel.sh
# check max virtual igpus
sudo cat /sys/module/i915/parameters/max_vfs
# set max virtual igpus
echo $VIRTUAL_GPU | sudo tee /sys/bus/pci/devices/0000:00:02.0/sriov_numvfvs

# check set virtual igpus
lspci | grep -i vga
