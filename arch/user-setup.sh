#!/bin/bash

# Variables used for formatting console output.
bold=$(tput bold)
normal=$(tput sgr0)

# Create tmp folder to download packages.
mkdir -p ~/tmp/pacaur_install
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

# Change shell to zsh.
chsh -s /bin/zsh

# Clean up.
cd ~/tmp
rm -r ~/tmp/pacaur_install

# Install packages
cat ~/packages.list | sed 's/#.*//' | xargs pacaur -S --noconfirm


# Install sublime-text from author repository
# https://www.sublimetext.com/docs/3/linux_repositories.html#pacman
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && \
  sudo pacman-key --add sublimehq-pub.gpg && \
  sudo pacman-key --lsign-key 8A8F901A && \
  rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | \
  sudo tee -a /etc/pacman.conf
pacaur -Syu sublime-text


# Install pip dependencies for Albert
sudo pip install lxml clipboard requests

# Clone dots and link them to the right config paths.
git clone --recursive https://github.com/nglgzz/dots ~/dots
~/dots/link.sh

# Remove .bash_profile so setup isn't executed again.
rm ~/.bash_profile
rm packages.list

# Create .zprofile so graphical interface is
# started automatically on login.
echo "startx" > ~/.zprofile
