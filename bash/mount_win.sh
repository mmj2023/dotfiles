# sudo mount -t ntfs-3g \
#   -o uid=1000,gid=1000,dmask=022,fmask=133,exec \
#   /dev/nvme0n1p4 $HOME/Windows-SSD
sudo mount -t ntfs3 -o defaults,prealloc,discard,uid=$(id -u),gid=$(id -g) /dev/nvme1n1p3 /mnt/windows
