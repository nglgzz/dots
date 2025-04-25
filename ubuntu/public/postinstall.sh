#!/bin/bash
set -eu

## Formatting
bold=$(tput bold)
normal=$(tput sgr0)

## Set default shell to zsh
# -F sets the delimiter, -v sets a variable
root_shell=$(awk -F: -v user="root" '$1 == user {print $NF}' /etc/passwd)
if [[ "$root_shell" != '/usr/bin/zsh' ]]; then
    echo "Changing root shell"
    sudo chsh -s /usr/bin/zsh
fi

user_shell=$(awk -F: -v user="$(whoami)" '$1 == user {print $NF}' /etc/passwd)
if [[ "$user_shell" != '/usr/bin/zsh' ]]; then
    echo "Changing $(whoami) shell"
    sudo chsh -s /usr/bin/zsh
fi

## Create an SSH key to be used to clone and commit to the repo
if [[ ! -f "$HOME/.ssh/github" ]]; then
    echo "Generating SSH key for GitHub, save the key at ${bold}$HOME/.ssh/github${normal}"
    ssh-keygen
    echo "Add the following public key to GitHub"
    echo ""
    xclip -selection clipboard <~/.ssh/github.pub || true
    cat ~/.ssh/github.pub
    echo ""
    read -p "Press enter when done"
fi

## Clone this repo and initialize the configuration files
if [[ ! -f "$HOME/.ssh/github" ]]; then
    git clone git@github.com:nglgzz/dots.git ~/dots
fi

cd ~/dots
make
