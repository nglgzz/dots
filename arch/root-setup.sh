#!/bin/bash

# Variables used for formatting console output.
bold=$(tput bold)
normal=$(tput sgr0)

# Username
read -p "${bold}Username: ${normal}" username


# Install sudo, create new user, add it to sudoers, and set password.
pacman -S --noconfirm sudo
useradd -m -G wheel $username
passwd $username
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Customize pacman
sed -i -r 's/#(Color|TotalDownload)/\1/g' /etc/pacman.conf

# Install zsh and set it as default shell.
pacman -S --noconfirm zsh
chsh -s /bin/zsh

# Install some common packages and pacaur dependencies.
pacman -S --noconfirm wget tar git unzip vim base-devel
pacman -S --noconfirm --needed expac yajl

# Remove .bash_profile, so the configuration script is not
# executed again.
rm ~/.bash_profile

# Add the configuration script for the user on its .bash_profile.
cp ~/user-setup.sh "/home/$username"
cp ~/packages.list "/home/$username"
chown $username "/home/$username/user-setup.sh"
chown $username "/home/$username/packages.list"
chown $username "/home/$username/.bash_profile"
echo "exec ~/user-setup.sh" > "/home/$username/.bash_profile"

# Check for updates
pacman -Syu --noconfirm
