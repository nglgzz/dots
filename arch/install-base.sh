#!/bin/bash

# Variables used for formatting console output.
bold=$(tput bold)
normal=$(tput sgr0)

# CPU vendor.
cpu_vendor=$(grep vendor /proc/cpuinfo | uniq | awk '{print $3}')

# Hostname
read -p "${bold}Hostname: ${normal}" hostname


# Generate and set system locale and keymap.
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=it" > /etc/vconsole.conf

# Select timezone and set clock to UTC.
ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
hwclock --systohc --utc

# Install bootloader.
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot \
  --bootloader-id=grub
mkdir /boot/EFI/boot
cp /boot/EFI/grub/grubx64.efi /boot/EFI/boot/bootx64.efi

# If you have Intel CPU, install intel-ucode.
if [[ $cpu_vendor == "GenuineIntel" ]]; then
  pacman -S --noconfirm intel-ucode
fi
grub-mkconfig -o /boot/grub/grub.cfg


# Network configuration.
echo $hostname > /etc/hostname
pacman -S --noconfirm wicd
systemctl enable wicd

# Change root password.
passwd

