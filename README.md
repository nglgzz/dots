# Dots
These are the dots files for my Arch environment.
The `arch` folder contains some scripts for installing Arch and configure it to
look like this.

The `link.sh` script links all configuration files to where they need to be.
**Do not run that script** without backing up your configs first. The script will
overwrite all files that already exist. Also, before running it be sure to read it
and make the necessary changes (eg. change the path to which the configs are linked).

There is a `remap.sh` script that can be used to remap colors on images (for example
to change the color of icons). This script will take a source color and a destination
color, then for each pixel of the image it will calculate the distance between the
actual color and the source color, and apply that to the destination color. It works
well with images that have similar colors, gives interesting results on other kinds
of images.

## Clean
I have two modes for polybar, the one you see here, and one where the bar takes the
whole length of the screen. I can change between them using `mod+shift+o` and `mod+shift+i`.
When I change to the other mode, windows have no gaps, and compton is killed, this is to
save space and resources when I'm on my laptop. I'm using the Hack font for text and Font
Awesome for icons. The widgets from left to right are i3 workspaces, current song playing (not
showing in this screenshot), volume, network, battery (not showing when I'm on desktop), CPU
usage, and date.
![Clean](http://i.imgur.com/6GoyrrX.png)

## Screenfetch
![Screenfetch](http://i.imgur.com/x84Fk09.png)


## Albert
The results you see here are all plugins I wrote, everything is available in my [albert-plugins repo](https://github.com/nglgzz/albert-plugins).

![Albert](http://i.imgur.com/cKn8JNS.png)


## Dirty
Changing the icons color on Sublime was a bit tricky, I ended up creating a script to
remap colors in an image using python-opencv (there's no way I'm going through each icon manually).
The theme I'm using on Sublime is [Material Theme](https://github.com/equinusocio/material-theme)
with a custom color scheme.
Here you can also see the current song script I mentioned above. This script shows the name
of the song I'm currently playing on YouTube.

![Sublime + Tmux](http://i.imgur.com/RIojD0p.png)


## Chromium
Mandatory [/r/unixporn](https://reddit.com/r/unixporn) for Reddit.

![Unixporn](http://i.imgur.com/1RYs49l.png)


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
to install Arch. **Once you choose it will delete everything on it**, and create 3 partitions:
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
- **alt+s**: screenshot, draw rectangle (same as above, but lets you choose which portion of the screen to capture)

**i3**
- **mod+shift+x**: lock screen (i3lock)
- **mod+shift+r**: restart i3
- **mod+shift+q**: exit i3
- **mod+shift+o**: disable gaps and kill compton (used for shadows)
- **mod+shift+i**: enable gaps and start compton (used for shadows)

**Workspace**
- **mod+[1-0]**: go to workspace 1 to 10
- **mod+Shift+[1-0]**: move focused window to workspace 1 to 10
- **mod+Tab**: back and forth between last two workspaces
- **mod+o**: container layout, tabbed
- **mod+p**: container layout, toggle split (vertical|horizontal)
- **mod+shift+p**: toggle between tiling and floating
- **mod+LeftClick**: to drag floating windows
- **mod+RigthClick**: to resize floating windows

**Window**
- **mod+[Left|Right|Up|Down]**: move focus
- **mod+[w|a|s|d]**: move focus
- **mod+Shift+[Left|Right|Up|Down]**: move focused window
- **mod+Shift+[w|a|s|d]**: move focused window
- **mod+f**: toggle fullscreen for focused window
- **mod+shift+c**: kill focused window
- **mod+Enter**: start terminal (termite)
- **mod+r**: start albert
- **mod+b**: start browser (chromium)
- **mod+c**: start code editor (sublime)
- **mod+k**: start slack

**Albert Plugins**
- **mod+r**: toggle albert
- **mod+g**: google search
- **mod+y**: youtube search
- **mod+v**: transform clipboard content with regex
- **mod+t**: google translate
- **mod+x**: learn anything search
- **mod+z**: cheat.sh search
- **mod+e**: wordreference (english/italian)

**Random**
- **mod+Shift+f**: execute the content of primary selection (selected text) in JS, and copy output on clipboard buffer


## Mappings
| Physical key | Key pressed alone | Key pressed as modifier (together with another key) |
|--------------|-------------------|-----------------------------------------------------|
| space        | space             | GUI key (mod)                                            |
| caps lock    | escape            | left control                                        |
| tab          | tab               | mode switch                                         |

### Mode Switch mappings
| Physical key | Key pressed with mode switch |
|--------------|------------------------------|
| w            | arrow up                     |
| a            | arrow left                   |
| s            | arrow down                   |
| d            | arrow right                  |
| q            | home                         |
| e            | end                          |
| g            | delete                       |
| h            | backspace                    |
| b            | enter                        |


## Notes
- At launch an instance of Chromium is executed.
- Workspaces 1,2, and 3 are bound to my primary screen, while 4 and 8 are bound to my secondary screen.

**Workspace bindings**
- **workspace 1**: Chromium
- **workspace 2**: Sublime
- **workspace 3**: Termite
- **workspace 8**: OBS, Chatty
