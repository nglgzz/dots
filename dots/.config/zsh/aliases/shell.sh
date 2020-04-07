declare -A shell=(
  # Commands
  [vim]=nvim
  [cat]=bat
  [_cat]='command cat'
  [e]='code .'
  [q]='exit'
  [l]='ls -ah --color=tty'
  [ll]='ls -lha --color=tty'
  # Configs
  [zedit]='nvim $ZDOTDIR/.zshrc && source $ZDOTDIR/.zshrc'
  [zource]='source $ZDOTDIR/.zshrc'
  [i3edit]='nvim $XDG_CONFIG_HOME/i3/config && i3-msg restart'
  [codex]='code --list-extensions'
  # Navigation
  [b]='cd -'
  [tmp]='cd ~/tmp'
  [..]='cd ..'
  # Utils
  [copy]='xclip -selection clipboard'
  [paste]='xclip -out -selection clipboard'
  [serve]='python -m http.server'
)

function tousb() {
  sudo dd bs=4M if=$1 of=$2 status=progress
}

function cheat() {
  curl "cheat.sh/$1"
}

# Mount LUKS encrypted device
function emount() {
  sudo cryptsetup open "/dev/$1" "crypt_$1"
  sudo mount "/dev/mapper/crypt_$1" $2
}

# Unmount LUKS encrypted device
function eumount() {
  sudo umount $2
  sudo cryptsetup close "crypt_$1"
}
