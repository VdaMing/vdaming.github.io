title: Install Archlinux on Raspi B+
date: 2016-01-02 20:44:29
tags: RaspberryPi
category: Tool
---
# 树梅派B+制作Arch linux系统步骤

1. 从[官网](http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz)，或者是国内的镜像站比如清华大学*http://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/os/ArchLinuxARM-rpi-latest.tar.gz*下载最新的arch linux arm镜像文件
2. 按照官方给出的步骤制作SD卡
> Replace sdX in the following instructions with the device name for the SD card as it appears on your computer.
> 1. Start fdisk to partition the SD card:
> ` fdisk /dev/sdX `
> 2. At the fdisk prompt, delete old partitions and create a new one:
>  a. Type *o*. This will clear out any partitions on the drive. 
>  b. Type *p* to list partitions. There should be no partitions left. 
>  c. Type *n*, then *p* for primary, *1* for the first partition on the drive, press ENTER to accept the default first sector, then type *+100M* for the last sector.
>  d. Type *t*, then *c* to set the first partition to type W95 FAT32 (LBA). 
>  e. Type *n*, then *p* for primary, *2* for the second partition on the drive, and then press ENTER twice to accept the default first and last sector. 
>  f. Write the partition table and exit by typing *w*.
> 3. Create and mount the FAT filesystem:
> ` mkfs.vfat /dev/sdX1 `
> ` mkdir boot `
> ` mount /dev/sdX1 boot `
> 4. Create and mount the ext4 filesystem:
> ` mkfs.ext4 /dev/sdX2 `
> ` mkdir root `
> ` mount /dev/sdX2 root `
> 5. Download and extract the root filesystem (as root, not via sudo):
> ` wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz `
> ` bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C root `
> ` sync `
> 6. Move boot files to the first partition:
> ` mv root/boot/* boot `
> 7. Unmount the two partitions:
> ` umount boot root `
> 8. Insert the SD card into the Raspberry Pi, connect ethernet, and apply 5V power.
> 9. Use the serial console or SSH to the IP address given to the board by your router.
> 10. Login as the default user alarm with the password alarm.The default root password is root.

Archlinux wiki page: https://wiki.archlinux.org/index.php 
