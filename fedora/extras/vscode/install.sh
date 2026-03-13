#!/bin/bash -eux

current_dir=$(dirname "$0")

sudo rpmkeys --import https://packages.microsoft.com/keys/microsoft.asc
sudo cp "$current_dir"/vscode.repo /etc/yum.repos.d/
sudo dnf --assumeyes install code
