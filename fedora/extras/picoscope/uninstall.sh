#!/bin/bash -eu

sudo dnf --assumeyes remove picoscope
sudo rm /etc/yum.repos.d/picoscope.repo

picoscope_rpmkey=$(rpmkeys --list | grep "picotech" | awk '{print $1}')
sudo rpmkeys --delete "$picoscope_rpmkey"
