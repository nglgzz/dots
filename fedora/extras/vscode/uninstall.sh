#!/bin/bash -eu

sudo dnf --assumeyes remove code
sudo rm /etc/yum.repos.d/vscode.repo

picoscope_rpmkey=$(rpmkeys --list | grep "microsoft" | awk '{print $1}')
sudo rpmkeys --delete "$picoscope_rpmkey"
