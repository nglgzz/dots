# Dots
Here are the dot files for my Debian environment.
I also made a script to bring a fresh Debian installation to look like my current desktop.

## Clean 
I'm using the Roboto Mono font for the top bar text and ont Awesome for the icons. 
The status bar is generated using i3blocks, currently I have it to show (starting from right) 
date&time, CPU usage, eth0 status, wlan0 status, mic volume (it's not present in some screenshots 
as I added it later) and audio volume.

![img](http://imgur.com/ONSzoEz)

## Dirty
Here, I'm using Sublime Text, Terminator and Thunar. The theme I'm using in Sublime is [Material Theme](https://github.com/equinusocio/material-theme) as for GTK I set [Arc Theme](https://github.com/horst3180/arc-theme) with [Paper Icons](https://snwh.org/paper).

![img](http://imgur.com/s1yISwT)

## Chromium
Nothing special going on here.

![img](http://imgur.com/5TJcTIn)

## Rofi
My choice for program launcher is [Rofi](https://github.com/DaveDavenport/rofi), I haven't done too much customization here, just tried to keep it simple. 

![img](http://imgur.com/fHOta2v)

## Installation
Just clone this repo and run the `first_setup.sh` script from your home in a fresh Debian installation, it may take a while since it will install all the basic programs, and their dependencies.

## Shortcuts
Most of the shotcuts are the standard i3 shortcuts, others come from AwesomeWM, I'll write here some of the ones that differ from standard i3 shortcuts:

- `mod+b` start browser (chromium)
- `mod+e` start editor (sublime) 
- `mod+r` run rofi
- `mod+shift+r` reload i3
- `mod+shift+c` kill focused window
- `shift+VolumeUp` turn up mic volume
- `shift+VolumeDown` turn down mic volume
- `mod+shift+p` toggle tiling/floating
- `mod+p` container layout, toggle split
- `mod+o` container layout, stacking
- `mod+l` container layout, tabbed
- `mod+shift+x` lock screen (i3lock)
- `mod+shift+q` exit i3

## Notes
At launching are executed Chromium, Sublime and two Terminator instances. Chromium is binded to workspace 1, Sublime to workspace 2 and Terminator to workspace 3. I tried to bind Spotify to workspace 9 but there seem to be an [issue](https://github.com/i3/i3/issues/2060) with that.