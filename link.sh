#!/bin/bash

# Any error or undefined variable will make the script exit immediately.
set -eu

# This script should be safe to run multiple times. I always forget about this
# and end up wasting time being overly cautious, so I'll write this here as a
# reminder.

# Link source to destination
# _link src dst
function _link() {
  destination=$(dirname "$2")
  # If destination folder doesn't exist,
  # create the folder.
  if [[ ! -d "$destination" ]]; then
    mkdir -p "$destination"
  fi

  # If destination exists remove it.
  if [[ -e "$2" ]] || [[ -L "$2" ]]; then
    rm -r "$2"
  fi

  echo "linking $2"
  ln -s "$1" "$2"
}

# Path variables
dots=$HOME/dots/dots
config_source="$dots/.config"
config_target=$HOME/.config
code_source="$config_source/Code/User"
code_target="$config_target/Code/User"
ignore=(.config etc-systemd 'Code')

# Link all folders in $config_source to ~/.config
for dir in $(find "$config_source" -mindepth 1 -maxdepth 1 -type d); do
  dir=$(basename "$dir")
  # Make sure that the current folder is not on the list of folders to
  # be ignored
  if [[ ! " ${ignore[@]} " =~ " ${dir} " ]]; then
    _link "$config_source/$dir" "$config_target/$dir"
  fi
done

# Link all folders and files in $dots to ~
for file_or_dir in $(find "$dots" -mindepth 1 -maxdepth 1); do
  file_or_dir=$(basename "$file_or_dir")
  # Make sure that the current folder is not on the list of folders to
  # be ignored
  if [[ ! " ${ignore[@]} " =~ " ${file_or_dir} " ]]; then
    _link "$dots/$file_or_dir" "$HOME/$file_or_dir"
  fi
done

# Link all folders and files in $code to ~/.config/Code - OSS/User
for file_or_dir in $(find "$code_source" -mindepth 1 -maxdepth 1); do
  file_or_dir=$(basename "$file_or_dir")
  # Make sure that the current folder is not on thest of folders to
  # be ignored
  if [[ ! " ${ignore[@]} " =~ " ${file_or_dir} " ]]; then
    _link "$code_source/$file_or_dir" "$code_target/$file_or_dir"
  fi
done
# Install VS Code extensions
cat "$code_source/../extensions.list" | xargs -L 1 code --force --install-extension

# Create empty folder for syncing.
mkdir -p ~/projects

rm -rf ~/.config/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/.zsh/zsh-autosuggestions
nvim +PlugInstall
