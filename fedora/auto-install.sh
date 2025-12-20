#!/bin/bash -eu

# Install packages
sudo dnf --assumeyes --quiet install \
    make zsh neovim bat fzf yq btop \
    gh git-delta \
    source-foundry-hack-fonts \
    gnome-tweaks gnome-extensions-app \
    kicad firefox \
    podman-docker podman-compose

flatpak install --assumeyes \
    com.usebottles.bottles \
    com.github.tchx84.Flatseal \
    com.brave.Browser \
    org.telegram.desktop \
    com.valvesoftware.Steam \
    org.onlyoffice.desktopeditors \
    com.synology.SynologyDrive \
    org.videolan.VLC \
    com.discordapp.Discord \
    md.obsidian.Obsidian \
    org.telegram.desktop \
    md.obsidian.Obsidian \
    io.podman_desktop.PodmanDesktop \
    com.prusa3d.PrusaSlicer

# Change default shell
if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    chsh -s /usr/bin/zsh
    echo "Changed default shell to zsh"
fi

# Log into GitHub
if ! gh auth status; then
    gh auth login
fi

# Clone dots folder
if [[ ! -d "$HOME/dots" ]]; then
    gh repo clone nglgzz/dots
fi

# Install zed editor
if ! which zed &>/dev/null; then
    curl -f https://zed.dev/install.sh | sh
fi

make -C $HOME/dots \
    links \
    zsh-setup \
    vim-setup \
    load-gnome-settings \
    install-gnome-extensions
