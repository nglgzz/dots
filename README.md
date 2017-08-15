# Dots
These are the dots files for my Arch environment.
The `arch` folder contains some scripts for installing Arch and configure it to
look like this.

The `link.sh` script links all configuration files to where they need to be.
**Do not run that script** without backing up your configs first. The script will
overwrite all files that already exist. Also, before running it be sure to read it
and make the necessary changes (eg. change the path from which the configs are linked).


## Clean | Background
This is a clean workspace, all you see is the background. This is because by
default the i3bar mode is set to hide (shows only while pressing `mod`). You can
rotate between hide and dock (always showing) mokdes by pressing `mod+y`. I usually
keep the bar docked on my desktop, while hide it on my laptop.

![Clean | Background](http://i.imgur.com/Cjg9aym.png)

This is with the i3bar showing. I'm using the Fira font for text and Font Awesome
for icons. The status bar is generated using i3blocks, and it shows (starting from right)
date & time, my local IP, CPU usage, mic and speaker volume. On my laptop I also
have the battery status in there.

![Clean + Mod4](http://i.imgur.com/K6oLP9z.png)


## Screenfetch
I switched from Terminator to Termite cause it should be lighter and I wasn't
using any of the cool features Terminator has.

![Screenfetch](http://i.imgur.com/L4t2oWR.png)


## Albert
Another change I made is going from Rofi to Albert. The reason for this is that I
plan to write my own plugins and Albert seems easier to extend.

![Albert](http://i.imgur.com/eyMpMTr.png)


## Dirty
Here I have Sublime Text, Termite and Vim. On Sublime I'm using [Material Theme](https://github.com/equinusocio/material-theme)
with a few changes on the color scheme.

![Sublime + Vim + Termite](http://i.imgur.com/lxv0tGK.png)


## Chromium
Mandatory [/r/unixporn](https://reddit.com/r/unixporn) for Reddit. Also there's
a Dunst notification. I'm using [Paper Icons](https://snwh.org/paper) for the notification
icons, but in this case it's an image from Spotify.

![Unixporn + Dunst notification](http://i.imgur.com/YStFSNC.png)


## Scripts
`install.sh`, `install-base.sh` and `root-setup.sh` on the `arch` folder are generic scripts
to install Arch, and they're an implementation of [Arch linux for dummies](https://github.com/jieverson/dotfiles/wiki/arch-linux-for-dummies).

`user-setup.sh` is the script that installs pacaur, all the other packages I need (which are listed
on `packages.list`), clones my local repo with all my projects and then calls the `link.sh` script.
This script is very specific to my system, so if you want to use it you should edit it.

It takes a while for all the scripts to run, especially if on a slow internet connection.
The way this scripts are supposed to be executed is by booting an Arch installation
media with UEFI mode enabled, and then run the one liner in [this gist](https://gist.github.com/nglgzz/4bf8bc1a53a126ecf555f942dc05102f).

The script will show you the available devices and ask you in which one you want
to install Arch. Once you choose it will delete everything on it, and create 3 partitions:
boot, swap (double the size of your ram), and primary (all the remaining space).
Later it will ask for hostname and root password.

After rebooting log in as root, `root-setup.sh` will be executed automatically and
when done it will log out. This script will ask information for creating a new user.

Finally log in as the new created user and the `user-setup.sh` script is executed.


## Shortcuts
Here's the complete list of all configured shortcuts, grouped by category.

**System**
- **[VolumeUp|VolumeDown]**: turn speaker volume up or down
- **Mute**: mute speaker
- **Shift+[VolumeUp|VolumeDown]**: turn mic volume up or down
- **MuteMic**: mute mic
- **alt+Shift+s**: screenshot (saved on '~/tmp/screenshot.png' and copied to clipboard)
- **alt+s**: screenshot, draw rectangle

**i3**
- **mod+y**: toggle i3bar mode (hide | dock)
- **mod+shift+x**: lock screen (i3lock)
- **mod+shift+r**: reload i3
- **mod+shift+q**: exit i3

**Workspace**
- **mod+[1-0]**: go to workspace 1 to 10
- **mod+Shift+[1-0]**: move focused window to workspace 1 to 10
- **mod+Tab**: back and forth between last two workspaces
- **mod+l**: container layout, tabbed
- **mod+o**: container layout, stacking
- **mod+p**: container layout, toggle split
- **mod+h**: split in horizontal orientation
- **mod+v**: split in vertical orientation
- **mod+shift+p**: toggle between tiling and floating
- **mod+LeftClick**: to drag floating windows
- **mod+RigthClick**: to resize floating windows

**Window**
- **mod+[Left|Right|Up|Down]**: move focus
- **mod+Shift+[Left|Right|Up|Down]**: move focused window
- **mod+Enter**: start terminal (termite)
- **mod+r**: start albert
- **mod+b**: start browser (chromium)
- **mod+e**: start editor (sublime)
- **mod+k**: start slack
- **mod+f**: toggle fullscreen for focused window
- **mod+shift+c**: kill focused window
- **mod+d**: enter resize mode (use arrows or mouse to resize, enter or escape to exit)

## Notes
At launch an instance of Chromium is executed.

**Workspace bindings**
- **workspace 1**: Chromium
- **workspace 2**: Sublime
- **workspace 3**: Termite
- **workspace 4**: Slack
- **workspace 9**: Spotify
