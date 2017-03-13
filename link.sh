home=${1:-"$HOME"}
user=${2:-"$(whoami)"}
dots=$(dirname $(realpath $0))

# link src dst [name]
_link() {
  if [[ -d $2 ]]; then
    echo "#  Backing up existing $3 to $2.back.zip"
    zip $2.back.zip $2 -r
    rm -r $2
  fi

  if [[ -f $2 ]]; then
    echo "#  Backing up existing $3 to $2.back"
    mv $2 $2.back
  fi

  echo "#  Linking $3"
  ln -s $1 $2
  chown -Rh $user:$user $2
}

# link dot files
_link $dots/i3 $home/.i3 'i3 dots'
_link $dots/terminator/config $home/.config/terminator/config 'terminator config'
_link $dots/gtk-3.0/settings.ini $home/.config/gtk-3.0/settings.ini 'GTK styling'
_link $dots/vim/vimrc $home/.vimrc 'vimrc'

_link "$dots/sublime-text-3/Package Control.sublime-settings"\
 "$home/.config/sublime-text-3/Packages/User/Package Control.sublime-settings" 'sublime packages'
_link $dots/sublime-text-3/Preferences.sublime-settings\
 $home/.config/sublime-text-3/Packages/User/Preferences.sublime-settings 'sublime preferences'