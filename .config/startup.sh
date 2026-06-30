mount -t ntfs-3g -o uid=1000,gid=1000,umask=022 /dev/nvme0n1p4 /mnt/windows/Pablo_D
mount -t cifs //192.168.1.101/NAS_root /mnt/samba/NAS_root -o credentials=/home/pablo/.config/.env,uid=1000,gid=1000
