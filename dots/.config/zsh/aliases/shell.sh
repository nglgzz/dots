declare -A shell=(
  # Commands
  [vim]=nvim
  [cat]=bat
  [_cat]='command cat'
  [e]='code .'
  [q]='exit'
  [l]='ls -ah --color=tty'
  [ll]='ls -lha --color=tty'
  [watch]='watch --color -n1'
  # Configs
  [zedit]='cd ~/dots && nvim $ZDOTDIR/.zshrc && source $ZDOTDIR/.zshrc && cd -'
  [ale]='cd $ZDOTDIR/aliases && nvim $(fzf) && source $ZDOTDIR/.zshrc && cd -'
  [zource]='source $ZDOTDIR/.zshrc'
  [i3edit]='nvim $XDG_CONFIG_HOME/i3/config'
  [codex]='code --list-extensions'
  # Navigation
  [b]='cd -'
  [tmp]='cd ~/tmp'
  [dots]='cd ~/dots'
  [..]='cd ..'
  [...]='cd ../..'
  [....]='cd ../../..'
  [.....]='cd ../../../..'
  # Utils
  [copy]='xclip -selection clipboard'
  [paste]='xclip -out -selection clipboard'
  [serve]='python -m http.server'
  [free-port]=free_port
)

function free_port() {
  local pid=$(netstat -ltnp | grep ':'$1 | awk '{print $7}' | sed 's|/.*||')
  kill $pid 2>/dev/null || true
}

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
