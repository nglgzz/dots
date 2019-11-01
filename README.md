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
save space and resources when I'm on my laptop. I'm using the Hack font for text and
Material Icons for icons. The widgets from left to right are i3 workspaces, current song playing (not
showing in this screenshot), volume, network, battery (not showing when I'm on desktop), CPU
usage, and date.
![Clean](http://i.imgur.com/6GoyrrX.png)

## Screenfetch

![Screenfetch](http://i.imgur.com/x84Fk09.png)

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

## Notes

- At launch an instance of Chromium is executed.
- Workspaces 1,2, and 3 are bound to my primary screen, while 4 and 8 are bound
  to my secondary screen (if connected).

**Workspace bindings**

- **workspace 1**: Chromium
- **workspace 3**: Termite
- **workspace 8**: OBS, Chatty
