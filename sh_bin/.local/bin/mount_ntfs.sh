
#!/usr/bin/env bash

# mount_ntfs.sh

# mounts a NTFS partition


# if [ $# -ne 1 ]; then
#  # check if /dev/nvme0n1p4 exists and it contains a NTFS partition
#  # if so, mount it
#  if [ -f /dev/nvme0n1p4 ]; then
#   sudo mount -t ntfs-3g /dev/nvme0n1p4 ~/Windows-SSD/
#   exit 0
#  else
#   echo "usage: mount_ntdfs.sh <device>"
#   exit 1
#  fi
# else
#  sudo mount -t ntfs-3g $1 $2
# fi
sudo mount -t ntfs-3g $1 $2
