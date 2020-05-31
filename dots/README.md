# [Dots](../README.md) – Dots

## Files

- **.bin** – Scripts used by other configs (mostly i3). All executables in
  this directory are available on PATH. Scripts in **.bin/extra** are
  gitignored.
- **.themes** – Custom GTK theme(s).
- **.config** – Configuration directories for most things that need to be
  configured.
- **.zshenv** – Entry point for ZSH configuration. The rest of the
  configuration is in **.config/zsh**.

## Zsh

Since my **.zshrc** file was becoming too big to comfortably navigate I split it
into more manageable chunks. Now there is a main file that imports the theme and
aliases.

Aliases are grouped by the programs they alias (with exception of shell and
keyboard). Alias files define most of their aliases through an associative
array, this is partially for readability, but also to make it possible to list
all aliases related to a program when running `aliases <command>`.

## Scripts

**[i3-resurrect-all](./.bin/i3-resurrect-all)**

Save and restore the layout (using i3-resurrect) and programs in all i3
workspaces. At the moment I have keybindings calling this script.

_Example usage:_

```bash
# Will prompt (with rofi) for a name, and save all workspaces in
# ~/.config/i3/profiles/<provided-name>
i3-resurrect-all save

# Will prompt to select a profile, and restore all workspaces saved in it.
i3-resurrect-all restore
```

**[rofi-input](./bin/rofi-input)**

Use rofi to get user input.

_Example usage:_

```bash
# Will open rofi with no options available and one line only, will return
# whatever it's typed on rofi.
rofi-input

# Add some options to choose from in the prompt, show only 5 options at
# the time, and change the text in the prompt to show "screen layout: ".
ls path/to/layouts | rofi-input "screen layout" 5
```

**[screengrab](./.bin/screengrab)**

Uses slop to select a region of the screen, an ffmpeg to record it. When
done it will paste the path to the video on the clipboard.

_Example usage:_

```bash
screengrab start
screengrab stop
```

**[project-find](./.bin/project-find)**

Performs a breadth first search on the ~/projects directory partially matching
the search string provided. Outputs the absolute path to the first directory
matching the criteria. It skips a set of ignored directories (eg. .git,
node_modules), and requires node to run.

_Example usage:_

```bash
project-find 42
/home/nglgzz/projects/nglgzz/42
```
