#!/bin/bash

# Any error or undefined variable will make the script exit immediately.
set -eu


# CHECK REQUIREMENTS
## Internet connection
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ !$? -eq 0 ]]; then
  echo "ERROR: no internet connection."
  echo "Check that the cable is connected or run wifi-menu to connect to the WiFi."
  exit 1
fi

## UEFI mode
if [[ ! -d /sys/firmware/efi/efivars ]]; then
  echo "ERROR: UEFI mode is not enabled."
  echo "Reboot and make sure to have UEFI enabled."
  exit 1
fi

## No mounted partitions
if [[ $(mount | grep -c "/mnt/boot") != 0 ]]; then
  echo "ERROR: boot partition mounted"
  echo "Unmounting /mnt/boot"
  umount /mnt/boot || exit 1
fi
if [[ $(mount | grep -c "/mnt") != 0 ]]; then
  echo "ERROR: root partition mounted"
  echo "Unmounting /mnt"
  umount /mnt || exit 1
fi
if [[ $(grep -c "/dev/" /proc/swaps) != 0 ]]; then
  swap_device=$(grep "/dev/" /proc/swaps | awk '{print $1}')
  echo "ERROR: swap partition mounted"
  echo "Unmounting $swap_device"
  swapoff $swap_device || exit 1
fi


# PREPARE
## Locale
loadkeys us
timedatectl set-timezone Europe/Rome
timedatectl set-ntp true
timedatectl status

## Generate variables used during installation.
source ./variables.sh

# INSTALL
## Create partitions
parted $device -s mklabel gpt
parted $device -s mkpart ESP fat32 1MiB 513MiB
parted $device set 1 boot on
parted $device -s mkpart primary linux-swap 514MiB $(expr $ram \* 2)GB
parted $device -s mkpart primary ext4 $(expr $ram \* 2)GB 100%

## Format partitions
mkfs.fat -F32 $device"1"
mkswap $device"2"
mkfs.ext4 $device"3"
fdisk -l $device

## Mount partition
swapon $device"2"
mount $device"3" /mnt
mkdir /mnt/boot
mount $device"1" /mnt/boot

## Install base packages
pacstrap /mnt
genfstab -U /mnt >> /mnt/etc/fstab

## Chroot
cp chroot.sh packages.list /mnt/root/
chmod +x /mnt/root/*.sh
arch-chroot /mnt env \
  hostname=$hostname \
  username=$username \
  /root/chroot.sh

# FINISH
read -p "${bold}Installation almost completed, press enter to reboot.${normal}"
reboot
