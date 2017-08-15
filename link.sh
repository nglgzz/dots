#!/bin/bash

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

# Clone a repo from Github
# _clone user/repo [path]
_clone() {
  if [[ ! -d $2 ]]; then
    git clone https://github.com/$1.git $2 --recursive
  fi
}

# Path variables
dots=~/projects/.dots/config
config=~/.config
vim_bundle=~/.vim/bundle
vim_colors=~/.vim/colors
ignore=(vim sublime-text-3)

_link ~/projects/.gitconfig ~/.gitconfig
_link ~/projects/.ssh ~/.ssh
_link ~/projects/.zshrc ~/.zshrc
_link $dots/albert/albert.conf $config/albert.conf

# Walk dirs in dots/config folder, and link them
# in ~/.config folder.
for dir in $(find $dots -type d -not -wholename $dots)
do
  dir=$(basename "$dir")
  if [[ ! " ${ignore[@]} " =~ " ${dir} " ]]; then
    _link $dots/$dir $config/$dir
  fi
done

# .vimrc and vim plugins
_link $dots/vim/vimrc ~/.vimrc
_link $dots/vim/autoload ~/.vim/autoload

mkdir -p $vim_bundle
_clone jiangmiao/auto-pairs $vim_bundle/auto-pairs
_clone pangloss/vim-javascript $vim_bundle/vim-javascript
_clone valloric/youcompleteme $vim_bundle/youcompleteme
cd $vim_bundle/youcompleteme
./install.py --all

mkdir -p $vim_colors
cd $vim_colors

if [[ ! -f PaperColor.vim ]]; then
  wget https://raw.githubusercontent.com/nlknguyen/papercolor-theme/master/colors/PaperColor.vim
fi

# Sublime
_link "$dots/sublime-text-3/Package Control.sublime-settings"\
  "$config/sublime-text-3/Packages/User/Package Control.sublime-settings"
_link "$dots/sublime-text-3/Preferences.sublime-settings"\
  "$config/sublime-text-3/Packages/User/Preferences.sublime-settings"
_link "$dots/sublime-text-3/Default (Linux).sublime-keymap"\
  "$config/sublime-text-3/Packages/User/Default (Linux).sublime-keymap"
cp $dots/Even-Darker.* $config/sublime-text-3/
