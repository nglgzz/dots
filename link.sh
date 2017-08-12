#!/bin/bash

# Link source to destination
# _link src dst
_link() {
  # If destination folder doesn't exist,
  # create the folder.
  if [[ ! -d "$(dirname $2)" ]]; then
    mkdir -p "$(dirname $2)"
  fi

  # If destination exists remove it.
  if [[ -e "$2" ]]; then
    rm -r "$2"
  fi

  ln -s "$1" "$2"
}

# Clone a repo from Github
# _clone user/repo [path]
_clone() {
  git clone https://github.com/$1.git $2
}

# Path variables
dots=~/projects/.dots
config=~/.config
vim_bundle=~/.vim/bundle
vim_colors=~/.vim/colors

_link ~/projects/.gitconfig ~/.gitconfig
_link ~/projects/.zshrc ~/.zshrc
_link $dots/i3 $config/i3
_link $dots/gtk-3.0 $config/gtk-3.0

# .vimrc and vim plugins
_link $dots/vim/vimrc ~/.vimrc
_link $dots/vim/autoload ~/.vim/autoload
mkdir -p $vim_bundle
_clone jiangmiao/auto-pairs $vim_bundle/auto-pairs
_clone pangloss/vim-javascript $vim_bundle/vim-javascript
_clone valloric/youcompleteme $vim_bundle/youcompleteme
mkdir -p $vim_colors
cd $vim_colors
wget https://raw.githubusercontent.com/nlknguyen/papercolor-theme/master/colors/PaperColor.vim

# Sublime
_link "$dots/sublime-text-3/Package Control.sublime-settings" \
  "$config/sublime-text-3/Packages/User/Package Control.sublime-settings"
_link "$dots/sublime-text-3/Preferences.sublime-settings" \
  "$config/sublime-text-3/Packages/User/Preferences.sublime-settings"
_link "$dots/sublime-text-3/Default (Linux).sublime-keymap" \
  "$config/sublime-text-3/Packages/User/Default (Linux).sublime-keymap"
