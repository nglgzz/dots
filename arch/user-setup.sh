#!/bin/bash

# Variables used for formatting console output.
bold=$(tput bold)
normal=$(tput sgr0)

# Create tmp folder to download packages.
mkdir -p ~/tmp/pacaur_install
cd ~/tmp/pacaur_install

pacman -S meson gmock gtest

# Install "auracle-git" from AUR.
if [ ! -n "$(pacman -Qs auracle-git)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=auracle-git
  makepkg PKGBUILD --skippgpcheck --install --needed
fi

# Install "pacaur" from AUR.
if [ ! -n "$(pacman -Qs pacaur)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
  makepkg PKGBUILD --install --needed
fi

# Change shell to zsh.
chsh -s /bin/zsh

# Clean up.
cd ~/tmp
rm -r ~/tmp/pacaur_install

# Install packages
cat ~/packages.list | sed 's/#.*//' | xargs pacaur -S --noconfirm

# Clone dots and link them to the right config paths.
git clone --recursive https://github.com/nglgzz/dots ~/dots
~/dots/link.sh

# Clone project utils
git clone https://github.com/nglgzz/project-utils ~/projects/.utils

# Remove .bash_profile so setup isn't executed again.
rm ~/.bash_profile
rm packages.list

