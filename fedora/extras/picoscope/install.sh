#!/bin/bash -eux

current_dir=$(dirname "$0")

sudo rpmkeys --import http://labs.picotech.com/repomd.xml.key
sudo cp "$current_dir"/picoscope.repo /etc/yum.repos.d/
sudo dnf --assumeyes install picoscope

# Workaround for segmentation fault when starting the app. Also updates the icon
# because the default one is in .xpm format which seems to be deprecated (and
# doesn't show up in the menus).
#
# https://www.picotech.com/support/viewtopic.php?p=152263&sid=b8122b09fc5a8fee834e32deea5fad16#p152263
sudo cp "$current_dir"/ApplicationIcon.png /opt/picoscope/share/
sudo desktop-file-edit /usr/share/applications/picotech-picoscope.desktop \
	--set-key Exec --set-value 'env GLIBC_TUNABLES=glibc.rtld.execstack=2 /usr/bin/picoscope %U' \
	--set-icon /opt/picoscope/share/ApplicationIcon.png
