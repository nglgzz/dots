# Dots
These are the dot files for my Debian environment.
I added two scripts, one for bringing a fresh Debian installation to look like this, and a second one to update from another i3 ricing. The update script may not work if you don't have the same programs I have installed, in case you have problems with that you can check out the `init.sh` script, and see what you're missing.

## Clean
Right now on a clean workspace all you can see is the background. This is because the i3bar mode is set to hide, which means it won't show unless you're pressing `mod`. That mode can be changed with `mod+y` and it rotates between hide and dock (always showing).

![img](https://i.imgur.com/dAMMwdO.png)

This is how it looks when I'm pressing `mod` or when I change the i3bar mode to dock.
I'm using the Roboto Mono font for text and font Awesome for icons.
The status bar is generated using i3blocks, currently I have it to show (starting from right) date & time, CPU usage, eth0 status (it's not present in the screenshots, but it's there on the config), wlan0 status, mic volume and audio volume.

![img](https://i.imgur.com/PnwzE5c.png)

## Rofi
[Rofi](https://github.com/DaveDavenport/rofi) is my choice for program launcher, I haven't done a lot of customization here. Also in this screenshot seems like it's running fullscreen, but that's just cause it has the same color of my background and it's covering the text on it.

![img](https://i.imgur.com/Xy2D54h.png)

## Dirty
Here I'm using Sublime Text, Terminator and Thunar. The theme I'm using in Sublime is [Material Theme](https://github.com/equinusocio/material-theme), as for GTK I set [Arc Theme](https://github.com/horst3180/arc-theme) with [Paper Icons](https://snwh.org/paper). I added the configs for Sublime, Terminator and GTK, and they also update with the `update.sh` script.

![img](https://i.imgur.com/wmLXCMx.png)


## Chromium
Mandatory [/r/unixporn](https://reddit.com/r/unixporn) for Reddit.

![img](https://i.imgur.com/4TWud1c.png)

## Installation & Update
Just clone this repo on your home and run the `init.sh` script as super user (still from your home, I may fix that next time). It may take a while specially if on slow internet connections. It will install all basic programs, their dependencies, and towards the end it will copy the config files on the default config path for i3, Sublime Text, Terminator and GTK.

For updating same as installation but run `update.sh`. This one will just copy the configs from the repo to your system. You may want to backup your previous configs, since this script is replacing those with the new ones.

## Shortcuts
Most shotcuts are standard i3 shortcuts, others come from AwesomeWM. Below the complete list of all configured shortcuts, grouped by category.

**System**
- `[VolumeUp|VolumeDown]` turn speaker volume up or down
- `Mute` mute speaker
- `Shift+[VolumeUp|VolumeDown]` turn mic volume up or down
- `MuteMic` mute mic
- `Print` screenshot (saved on '~/tmp/')
- `alt+Print` screenshot, select window or draw rectangle

**i3**
- `mod+y` toggle i3bar mode (hide | dock)
- `mod+shift+x` lock screen (i3lock)
- `mod+shift+r` reload i3
- `mod+shift+q` exit i3

**Workspace**
- `mod+[1-0]` go to workspace 1 to 10
- `mod+Shift+[1-0]` move focused window to workspace 1 to 10
- `mod+Tab` back and forth between last two workspaces
- `mod+l` container layout, tabbed
- `mod+o` container layout, stacking
- `mod+p` container layout, toggle split
- `mod+h` split in horizontal orientation
- `mod+v` split in vertical orientation
- `mod+shift+p` toggle between tiling and floating
- `mod+Mouse` to drag floating windows

**Window**
- `mod+[Left|Right|Up|Down]` move focus
- `mod+Shift+[Left|Right|Up|Down]` move focused window
- `mod+r` run rofi
- `mod+b` start browser (chromium)
- `mod+e` start editor (sublime)
- `mod+f` toggle fullscreen for focused window
- `mod+shift+c` kill focused window
- `mod+d` enter resize mode (use arrows or mouse to resize, enter or escape to exit)

## Notes
At launch an instance of Chromium is executed. Chromium is binded to workspace 1, Sublime to workspace 2, and Terminator to workspace 3. I tried to bind Spotify to workspace 9, but there seem to be an [issue](https://github.com/i3/i3/issues/2060) with that.
