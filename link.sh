#!/bin/bash
# Link path from dots home to user home
# ./link.sh relative_path

# Any error or undefined variable will make the script exit immediately.
set -eu

HOME_SRC="$HOME/dots/dots"
HOME_DST="$HOME"
IGNORE=(.config 'Code')

src_file="$HOME_SRC/$1"
dst_file="$HOME_DST/$1"
dst_parent_dir=$(dirname "$HOME_DST/$1")
basename=$(basename "$HOME_SRC/$1")

if [[ "${IGNORE[@]}" =~ "${basename}" ]]; then
  exit
fi

# If destination folder doesn't exist,
# create the folder.
if [[ ! -d "$dst_parent_dir" ]]; then
  mkdir -p "$dst_parent_dir"
fi

# If destination exists or is a symbolic link remove it.
if [[ -e "$dst_file" ]] || [[ -L "$dst_file" ]]; then
  rm -r "$dst_file"
fi

ln -s "$src_file" "$dst_file"
echo -e "$dst_file\t$(tput dim)$src_file$(tput sgr0)" | sed "s|$HOME|~|g"
