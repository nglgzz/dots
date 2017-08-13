#!/bin/bash

# Check internet connection and exit
# script if you're offline.
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ !$? -eq 0 ]]; then
  echo "ERROR: no internet connection."
  echo "Check your connection and try again."
  exit 1
fi

#Check if UEFI mode is enabled and exit if you're not.
if [[ ! -d /sys/firmware/efi/efivars ]]; then
  echo "ERROR: UEFI mode not enabled."
  echo "Reboot and make sure to have UEFI enabled."
  exit 1
fi


# Variables used for formatting console output.
bold=$(tput bold)
normal=$(tput sgr0)

# RAM size in GB
ram=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram=$(expr $ram / 1000 / 1000)

# Set keyboard layout.
loadkeys it

# Set timezone and NTP, and print time.
timedatectl set-timezone Europe/Amsterdam
timedatectl set-ntp true
timedatectl status


# Show available devices and partitions, and
# ask for a device to install the system on.
while true; do
  clear
  fdisk -l
  echo -e "\n"
  read -p "${bold}Choose a device to install the system on (eg. sdb):${normal} " device

  # Check if device exists, show details of the
  # selected device, and ask for confirmation.
  device=/dev/$device

  if [[ -b $device ]]; then
    clear
    fdisk -l $device
    echo -e "\n${bold}Are you sure you want to overwrite this device?${normal}"

    select yn in "Yes" "No"; do
      case $yn in
        Yes ) break;;
        No ) break;;
      esac
    done

    # If device exists and user confirmed that wants to use
    # that device, then proceed.
    if [[ $yn == "Yes" ]]; then
      break
    fi
  fi
done

# Format and create boot, swap, and primary partitions.
# Boot will be 512Mb, swap double the RAM size, and primary the rest.
parted $device -s mklabel gpt
parted $device -s mkpart ESP fat32 1MiB 513MiB
parted $device set 1 boot on
parted $device -s mkpart primary linux-swap 514MiB $(expr $ram \* 2)GB
parted $device -s mkpart primary ext4 $(expr $ram \* 2)GB 100%

# Format boot and primary partitions
# and set up swap partition.
mkfs.fat -F32 $device"1"
mkswap $device"2"
swapon $device"2"
mkfs.ext4 $device"3"

# Show updated device.
fdisk -l $device

# Mount partitions
mount $device"3" /mnt
mkdir /mnt/boot
mount $device"1" /mnt/boot

# Install base packages
pacstrap /mnt
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot and setup
cp install-base.sh /mnt/root/
chmod +x /mnt/root/install-base.sh
arch-chroot /mnt /root/install-base.sh

# Set .bash_profile to execute configuration script on next login
cp root-setup.sh /mnt/root/
cp user-setup.sh /mnt/root/
cp package.list /mnt/root/
echo "exec ~/root-setup.sh" > /mnt/root/.bash_profile

# Reboot
clear
read -p "${bold}Installation almost completed, press enter to reboot.${normal}"
reboot

