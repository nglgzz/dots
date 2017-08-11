#!/bin/bash

# Create tmp folder to download packages.
mkdir ~/tmp/pacaur_install
cd ~/tmp/pacaur_install

# Install "cower" from AUR.
if [ ! -n "$(pacman -Qs cower)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
  makepkg PKGBUILD --skippgpcheck --install --needed
fi

# Install "pacaur" from AUR.
if [ ! -n "$(pacman -Qs pacaur)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
  makepkg PKGBUILD --install --needed
fi

# Change shell to zsh
chsh -s /bin/zsh

# Clean up.
cd
rm -r ~/tmp/pacaur_install
rm ~/.bash_profile

