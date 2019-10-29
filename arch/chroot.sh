#!/bin/bash

# Any error or undefined variable will make the script exit immediately.
set -eu


# Install bootloader.
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot \
  --bootloader-id=grub
mkdir /boot/EFI/boot
cp /boot/EFI/grub/grubx64.efi /boot/EFI/boot/bootx64.efi

# If you have Intel CPU, install intel-ucode.
cpu_vendor=$(grep vendor /proc/cpuinfo | uniq | awk '{print $3}')
if [[ $cpu_vendor == "GenuineIntel" ]]; then
  pacman -S --noconfirm intel-ucode
fi
grub-mkconfig -o /boot/grub/grub.cfg

# Generate and set system locale and keymap.
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf


# Select timezone and set clock to UTC.
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc --utc

# Network configuration.
echo $hostname > /etc/hostname
pacman -S --noconfirm wicd
systemctl enable wicd


# Install sudo, create new user and add it to sudoers.
pacman -S --noconfirm sudo
useradd -m -G wheel $username
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Set passwords for root and user.
echo "Set root password."
passwd
echo "Set ${username} password."
passwd $username

# Customize pacman
sed -i -r 's/#(Color|TotalDownload)/\1/g' /etc/pacman.conf

# Set zsh as default shell.
chsh -s /usr/bin/zsh
sudo -u nglgzz chsh -s /usr/bin/zsh

# Check for updates
pacman -Syu --noconfirm



# Install pacaur and default packages.
pacman -S --noconfirm meson gmock gtest

## Create tmp folder to download packages.
function as_user () {
  sudo -u $username $*
}
user_home="/home/$username"

as_user mkdir -p $user_home/tmp/pacaur_install
as_user mkdir $user_home/projects
cd $user_home/tmp/pacaur_install

## Install "auracle-git" from AUR.
if [ ! -n "$(pacman -Qs auracle-git)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=auracle-git
  as_user makepkg PKGBUILD --skippgpcheck --install --needed --noconfirm
fi

## Install "pacaur" from AUR.
if [ ! -n "$(pacman -Qs pacaur)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
  as_user makepkg PKGBUILD --install --needed --noconfirm
fi

## Clean up.
cd $user_home/tmp
rm -r $user_home/tmp/pacaur_install

## Install packages
packages=$(cat ~/packages.list | sed 's/#.*//')
as_user EDITOR=vim pacaur -S --noconfirm --noedit $packages


## Link dots and project utils
as_user git clone --recursive https://github.com/nglgzz/dots $user_home/dots
as_user $user_home/dots/link.sh
as_user git clone https://github.com/nglgzz/project-utils $user_home/projects/.utils
