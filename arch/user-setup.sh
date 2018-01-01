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

# Install osync
mkdir ~/bin
# TODO - eventually the stable branch will contain the fix to issue #126,
# when that happens this line can be uncommented, and the following two
# can be deleted.
# git clone -b "stable" https://github.com/deajan/osync ~/bin/osync
git clone https://github.com/deajan/osync ~/bin/osync
sed -i 's/IS_STABLE=no/IS_STABLE=yes/' ~/bin/osync/osync.sh

# Clone dots and link them to the right config paths.
git clone https://github.com/nglgzz/dots ~/dots
~/dots/link.sh

# Start timer that syncs the projects folder.
systemctl --user daemon-reload
systemctl --user start projects-sync.timer

# Remove .bash_profile so setup isn't executed again.
rm ~/.bash_profile

# Create .zprofile so graphical interface is
# started automatically on login.
echo "startx" > ~/.zprofile
