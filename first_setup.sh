#!/bin/bash

# check if super user, otherwise run sudo
if [ $EUID != 0 ]; then
	echo '>			Superuser permission is required.'
    sudo "$0" "$@"
    exit $?
fi

echo '>			Installing vim zip i3 i3blocks i3lock xinit and terminator.'
apt-get install sudo git vim zip i3 i3blocks i3lock xinit terminator --force-yes -qq


echo '>			Adding non-free repositories and adding jessie-backports.'

# remove non-free from repositories that contain non-free already
sed -r 's/^(deb .*)non-free *$/\1/' -i /etc/apt/sources.list
# add non-free to all repositories (all lines starting with 'deb ')
sed -r 's/^deb .*/& non-free/' -i /etc/apt/sources.list

# removes backports if present
sed -r 's/deb http:\/\/debian.jpleau.ca\/ jessie-backports main contrib non-free//' -i /etc/apt/sources.list
# add backports it 
echo 'deb http://debian.jpleau.ca/ jessie-backports main contrib non-free' >> /etc/apt/sources.list

echo '>			Refreshing packages.'
apt-get update -qq

echo '>			Installing network manager.' 
apt-get install wicd-gtk -qq

echo '>			Installing browser, volume controls and vlc.'
apt-get install chromium alsa-utils pavucontrol vlc --force-yes -qq

echo '>			Installing file manager.'
apt-get install thunar -qq

echo '>			Downloading Roboto_Mono font.'
wget -q https://fonts.google.com/download?family=Roboto%20Mono -O Roboto_Mono.zip
echo '>			Installing Roboto_Mono font.'
unzip Roboto_Mono.zip -d roboto-mono
mkdir /usr/share/fonts/truetype
mv roboto-mono /usr/share/fonts/truetype/
fc-cache -f
rm Roboto_Mono.zip

echo '>			Downloading Font Awesome.'
wget -q http://fontawesome.io/assets/font-awesome-4.7.0.zip -O fontawesome.zip
echo '>			Installing Font Awesome.'
unzip fontawesome.zip -d fontawesome
mkdir .fonts
mv fontawesome/font-awesome-4.7.0/fonts/* .fonts/
fc-cache -f
rm fontawesome.zip
rm -r fontawesome

echo '>			Installing build essentials for building programs.'
apt-get install build-essential autoconf automake pkg-config --force-yes -qq

echo '>			Downloading and installing sublime text 3.'
wget -q https://download.sublimetext.com/sublime-text_build-3126_amd64.deb -O sublime_text3.deb
dpkg -i sublime_text3.deb
rm sublime_text3.deb

echo '>			Installing Rofi dependencies.'
apt-get install libpango1.0-dev libpangocairo-1.0-0 libcairo2-dev libglib2.0-dev libxcb-xkb-dev libxcb-xinerama0-dev -qq
apt-get install libxcb1-dev xutils-dev libtool libxcb-util0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev -qq
apt-get install libstartup-notification0-dev -qq
apt-get install libxkbcommon-dev libxkbcommon-x11-dev --force-yes -qq

echo '>			Installing printscreen, wallpaper application and theme customization tool.'
apt-get install scrot feh toilet lxappearance software-properties-common --force-yes -qq


echo '>			Cloning xcb-util-xrm repository from https://github.com/Airblader/xcb-util-xrm.'
git clone --recursive https://github.com/Airblader/xcb-util-xrm.git --quiet

echo '>			Installing xcb-util-xrm.'
cd xcb-util-xrm
autoreconf -i
mkdir build
cd build
../configure
make
make install
cd ../..

echo '>			Cloning Rofi repository from https://github.com/DaveDavenport/rofi.'
git clone https://github.com/DaveDavenport/rofi.git --quiet

echo '>			Installing Rofi.'
cd rofi
git submodule update --init
autoreconf -i
mkdir build
cd build
../configure
make
make install
cd ../..

echo '>			Adding LIBDIR and LD_LIBRARY_PATH export in .bashrc'
echo "export LIBDIR='/usr/local/lib'" >> .bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBDIR" >> .bashrc
echo '>			Reload .bashrc'
source .bashrc

echo '>			Styling i3, i3blocks and Rofi.'
cp ./dots/i3/* .i3/

echo '>			Styling terminator.'
mkdir -p .config/terminator
cp ./dots/terminator.config .config/terminator/config

# https://github.com/horst3180/arc-theme
echo '>			Installing arc-theme GTK theme.'
wget http://download.opensuse.org/repositories/home:Horst3180/Debian_8.0/Release.key
apt-key add - < Release.key
rm Release.key
echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/Debian_8.0/ /' > /etc/apt/sources.list.d/arc-theme.list 
apt-get update -qq
apt-get install arc-theme --force-yes -qq

# https://snwh.org/paper/download
echo '>			Installing Paper icons.'
wget -q 'https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-icon-theme,16.04' -O paper-icon.deb
dpkg -i paper-icon.deb
apt-get install -f --force-yes -qq
rm paper-icon.deb

# Used for Media Keys (doesn't work for me)
https://github.com/acrisci/playerctl
echo '>			Installing Playerctl dependencies'
apt-get install gtk-doc-tools gobject-introspection

echo '>			Installing Playerctl'
git clone https://github.com/acrisci/playerctl
cd playerctl
./autogen.sh
make
make install

echo '>			Done, here is a couple of things you may want to do now:'
echo '>			- select arc-theme on lxappearance'
echo '>			- select paper icons on lxappearance'
echo '>			- install following packages for Sublime Text:'
echo '>					-Package Control'
echo '>					-Material Theme (blue accent)'
echo '>					-Emmet'
echo '>					-JSX'
echo '>			- install firmware-iwlwifi if on laptop'
echo '>			- run `adduser [username] sudo` to add user to sudoers.'