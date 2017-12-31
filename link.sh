#!/bin/bash

# This script should be safe to run multiple times. I always forget about this
# and end up wasting time being overly cautious, so I'll write this here as a
# reminder.

# Link source to destination
# _link src dst
_link() {
  # If destination folder doesn't exist,
  # create the folder.
  if [[ ! -d $(dirname "$2") ]]; then
    mkdir -p $(dirname "$2")
  fi

  # If destination exists remove it.
  if [[ -e "$2" ]] || [[ -L "$2" ]]; then
    rm -r "$2"
  fi

  echo "linking $2"
  ln -s "$1" "$2"
}

# Path variables
dots=~/dots/dots
config_source="$dots/.config"
config_target=~/.config
ignore=(.config sublime-text-3)

#_link ~/projects/.zshrc ~/.zshrc
#cp $dots/albert/albert.conf $config/albert.conf

# Link all folders in $config_source to ~/.config
for dir in $(find "$config_source" -mindepth 1 -maxdepth 1 -type d)
do
  dir=$(basename "$dir")
  # Make sure that the current folder is not on the list of folders to
  # be ignored
  if [[ ! " ${ignore[@]} " =~ " ${dir} " ]]; then
    _link $config_source/$dir $config_target/$dir
  fi
done

# Link all folders and files in $dots to ~
for file_or_dir in $(find "$dots" -mindepth 1 -maxdepth 1)
do
  file_or_dir=$(basename "$file_or_dir")
  # Make sure that the current folder is not on the list of folders to
  # be ignored
  if [[ ! " ${ignore[@]} " =~ " ${file_or_dir} " ]]; then
    _link $dots/$file_or_dir ~/$file_or_dir
  fi
done

# Sublime
_link "$config_source/sublime-text-3/Package Control.sublime-settings"\
  "$config_target/sublime-text-3/Packages/User/Package Control.sublime-settings"
_link "$config_source/sublime-text-3/Preferences.sublime-settings"\
  "$config_target/sublime-text-3/Packages/User/Preferences.sublime-settings"
_link "$config_source/sublime-text-3/Default (Linux).sublime-keymap"\
  "$config_target/sublime-text-3/Packages/User/Default (Linux).sublime-keymap"
cp $config_source/sublime-text-3/Even-Darker.* \
  "$config_target/sublime-text-3/Packages/User"
