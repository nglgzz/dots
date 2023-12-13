#!/bin/bash

# Any error or undefined variable will make the script exit immediately.
set -eu

### CHECK REQUIREMENTS
## Internet connection
if ! curl -I http://aur.archlinux.org; then
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
  umount /mnt/boot
fi
if [[ $(grep -c "/dev/" /proc/swaps) != 0 ]]; then
  swap_device=$(grep "/dev/" /proc/swaps | awk '{print $1}')
  echo "ERROR: swap partition mounted"
  echo "Unmounting $swap_device"
  swapoff "$swap_device"
fi
if [[ $(mount | grep -c "/mnt") != 0 ]]; then
  echo "ERROR: root partition mounted"
  echo "Unmounting /mnt"
  umount /mnt
  lvchange -an SystemVolGroup
  cryptsetup close cryptlvm
fi

### PREPARE
## Locale
loadkeys us
timedatectl set-timezone Europe/Rome
timedatectl set-ntp true
timedatectl status

## Generate variables used during installation.
source ./variables.sh

### INSTALL
## Partition the disk
parted "$device" -s mklabel gpt
# Boot partition (EFI)
parted "$device" -s mkpart ESP fat32 1MiB 513MiB
parted "$device" set 1 boot on
# System partition (encrypted - will contain swap + root)
parted "$device" -s mkpart primary ext4 514MiB 100%

# Create and open LUKS encrypted container
cryptsetup -y -q -v luksFormat "${device}p2"
cryptsetup open "${device}p2" cryptlvm

## Prepare logical volumes
# Create a physical volume on the opened LUKS container.
pvcreate /dev/mapper/cryptlvm
# Create a volume group adding the previously created physical volume.
vgcreate SystemVolGroup /dev/mapper/cryptlvm
# Create all logical volumes on the volume group.
lvcreate -L "$swap_size" SystemVolGroup -n swap
lvcreate -l 100%FREE SystemVolGroup -n root

## Format and mount each logical volume
mkfs.ext4 /dev/SystemVolGroup/root
mkswap /dev/SystemVolGroup/swap

swapon /dev/SystemVolGroup/swap
mount /dev/SystemVolGroup/root /mnt

## Format and mount boot partition
mkfs.fat -F32 "${device}p1"

mkdir /mnt/boot
mount "${device}p1" /mnt/boot

## Install base packages
# shellcheck disable=SC2046 # wordsplitting here is intentional
pacstrap /mnt $(sed 's/#.*//' pacman.list)
genfstab -U /mnt >>/mnt/etc/fstab

## Get UUID of system partition (used for grub.cfg)
UUID=$(blkid -s UUID -o value "${device}p2")

## Chroot
cp chroot.sh aur.list /mnt/root/
chmod +x /mnt/root/*.sh

arch-chroot /mnt env \
  hostname="$hostname" \
  username="$username" \
  UUID="$UUID" \
  /root/chroot.sh

# FINISH
read -rp "${bold}Installation almost completed, press enter to reboot.${normal}"
reboot
