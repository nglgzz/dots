#!/bin/bash
set -x

rm -f \
  install.sh \
  chroot.sh \
  variables.sh \
  pacman.list \
  aur.list

curl -o install.sh https://raw.githubusercontent.com/nglgzz/dots/master/arch/install.sh
curl -o chroot.sh https://raw.githubusercontent.com/nglgzz/dots/master/arch/chroot.sh
curl -o variables.sh https://raw.githubusercontent.com/nglgzz/dots/master/arch/variables.sh
curl -o pacman.list https://raw.githubusercontent.com/nglgzz/dots/master/arch/pacman.list
curl -o aur.list https://raw.githubusercontent.com/nglgzz/dots/master/arch/aur.list

chmod +x -- *.sh

./install.sh
