#!/usr/bin/bash
set -eu

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
    chsh -s /usr/bin/zsh
fi

## Create an SSH key to be used to clone and commit to the repo
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ ! -f "$SSH_KEY" ]]; then
    echo "Generating new SSH key"
    ssh-keygen -t ed25519 -f "$SSH_KEY"
    echo "Add the following public key to GitHub (copied to clibpoard)"
    echo ""
    xclip -selection clipboard <"${SSH_KEY}.pub" || true
    cat "${SSH_KEY}.pub"
    echo ""
    read -p "Press enter when done"
fi

## Clone this repo and initialize the configuration files
if [[ ! -d "$HOME/dots" ]]; then
    git clone git@github.com:nglgzz/dots.git ~/dots
fi

cd ~/dots
make

## Install NVM
if [[ ! $(command -v nvm) ]]; then
    export NVM_DIR="$HOME/.config/nvm"
    mkdir -p "$NVM_DIR"
    latest_nvm_release=$(curl -Ls \
        -H "Accept: application/vnd.github+json" \
        https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/"${latest_nvm_release}"/install.sh | bash
    # shellcheck source=/dev/null
    source "$NVM_DIR/nvm.sh"

    # Clear the zshrc entries added by nvm, as they are already there, just on a
    # different file.
    git checkout dots/.config/zsh/.zshrc
fi

# Install Node.js LTS
nvm install --lts

read -p "Setup completed, press enter to logout (this step is needed to reload GNOME extensions)"
gnome-session-quit
