#! /usr/bin/env bash
# sudo kexec -l /boot/vmlinuz-$(uname -r) \
#     --initrd=/boot/initramfs-$(uname -r).img \
#     --reuse-cmdline

sudo-rs kexec -l $1 \
    --initrd=$2 \
    --reuse-cmdline

sudo-rs kexec -e
