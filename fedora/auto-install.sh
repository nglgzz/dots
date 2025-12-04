#!/bin/bash -eux

# Packages installed from the Flathub remote.
flatpak install \
    com.brave.Browser \
    com.synology.SynologyDrive \
    io.podman_desktop.PodmanDesktop \
    org.onlyoffice.desktopeditors

# Packages installed from the Fedora remote.
flatpak install fedora \
    org.gnome.Extensions

sudo dnf install \
    zsh neovim bat btop fzf git-delta gh \
    yq source-foundry-hack-fonts \
    bottles steam gnome-tweaks podman \