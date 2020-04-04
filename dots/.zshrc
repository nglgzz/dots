# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="minimal"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf)
source $ZSH/oh-my-zsh.sh

# https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Reset aliases that will be overridden later.
unalias gc gca grb gcf

# Preferred terminal and editor for local and remote sessions
export TERM='xterm-256color'
export EDITOR='nvim'
alias vim='nvim'

## Aliases
# _configs
alias zedit='nvim ~/.zshrc && source ~/.zshrc'
alias zource='source ~/.zshrc'
alias i3edit='nvim ~/.config/i3/config'

# _keyboards
alias 42source='cd ~/projects/nglgzz/42/firmware && make'
alias 42edit='nvim ~/projects/nglgzz/42/firmware/42/keymaps/default/keymap.c'
alias 42='cd ~/projects/nglgzz/42/'

alias 16source='cd ~/projects/nglgzz/16/ && make'
alias 16edit='nvim ~/projects/nglgzz/16/keymaps/default/keymap.c'
alias 16='cd ~/projects/nglgzz/16'

alias xev-clean='xev | awk -F'\''[ )]+'\'' '\''/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'\'''

# _bookmarks
alias tmp='cd ~/tmp'
alias ngl='pcd nglgzz nglgzz'

# _dev utils
alias cat='bat'
alias _cat='command cat'
alias serve='python -m http.server'
alias e='code .'
alias eex='code --list-extensions > "$HOME/dots/dots/.config/Code - OSS/extensions.list"'

# _shell
alias q='exit'
alias l='ls -ah'
alias ll='ls -lha'
alias copy='xclip -selection clipboard'
alias paste='xclip -out -selection clipboard'

function tousb() {
  sudo dd bs=4M if=$1 of=$2 status=progress
}

# _navigation
alias b='popd 1>/dev/null'

# _npm
alias n='npm'
alias ni='npm install'
alias ns='npm start'
alias nb='npm run build'
alias nd='npm run dev'
alias nr='npm run'
alias nt='npm test'
alias ntw='npm run test:watch'
function pj() {
  cat package.json | jq .$1
}

export PATH=$PATH:~/.npm-global/bin

# _yarn
alias y='yarn'
alias ys='yarn start'
alias yd='yarn dev'
alias yt='yarn test'
alias ya='yarn add'
alias yb='yarn build'

# _git
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gdd='git diff HEAD'
alias gddd='git diff HEAD^1 HEAD'
alias ga='git add'
alias gp='git pull'
alias gg='git push origin $(current_branch)'
alias ggwp='git push --force-with-lease origin $(current_branch)'
alias go='git checkout'
alias gb='git branch'
alias gf='git fetch'
alias gl='git ls'
alias gls='git log --oneline | fzf'
function gcf() {
  commit=$(git ls | head -n10 | fzf | grep -oP '\[\K\w{7}(?=])')
  git commit --fixup $commit
}
alias gcff='git rebase --interactive --autosquash HEAD~10'
alias gca='git commit --amend'
alias gcaa='git commit --amend --no-edit'
alias grb='git fetch upstream && git rebase upstream/master'
alias gu='git fetch origin && git rebase origin/master'
alias grls='git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"- [%Cblue%h%Creset] %s"'
alias grls-nochore='grls | grep -vwi "chore"'

function gc() {
  arg="$*"
  git commit -m "$arg"
}

# _docker
alias d='docker'
alias db='docker build . -t'
alias dc='docker container'
alias de='docker exec -it'
alias drmi='docker rmi $(paste | awk '\''{print $3}'\'')'
alias dlog='docker logs $(dfind)'
alias dkill='docker kill $(dfind)'
function dfind() {
  if [ -z "$1" ]; then
    docker ps | tail -n +2 | fzf | awk '{print $1}'
  else
    docker ps | grep $1 | awk '{print $1}' | head -n1
  fi
}
function dsh() {
  docker exec -it $(dfind $1) /bin/bash
}

# _kubernetes
alias k='kubectl'
alias kp='kubectl get pods --namespace=frontend'
alias kd='kubectl get deployments --namespace=frontend'
alias ks='kubectl get services --namespace=frontend'
alias kdp='kubectl describe pods --namespace=frontend'
alias kdd='kubectl describe deployments --namespace=frontend'
alias kds='kubectl describe services --namespace=frontend'
alias kl='kubectl logs -f'

# _go
export PATH=$PATH:$HOME/go/bin/
export GO111MODULE=on
alias gol='/usr/bin/go'

# _curl
function cheat() {
  curl "cheat.sh/$1"
}
alias weather='curl wttr.in/..'

# _systemd
alias s='systemctl'
alias sstart='sudo systemctl start'
alias sstop='sudo systemctl stop'
alias srestart='systemctl restart'
alias sstatus='systemctl status'
alias slog='journalctl -f -u'
alias sreload='systemctl daemon-reload'

# _random
# In case there's no WiFi and I have internet access via cable, I can create an
# access point so I can share the connection with my phone.
alias lettherebewifi="sudo create_ap wlp3s0 enp0s25 'Gluten-Free Fair Trade WiFi' ALLLOWERCASEWITHSPACES"
alias kb='setxkbmap'

# 10 most used commands, can show more or less appending "-n15" for example
alias topten='history | awk '\''{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10'

function en() {
  setxkbmap us
  xmodmap ~/.xmodmaprc
  pkill xcape
  xmodmap -e "clear Lock"
  xmodmap -e "add Control = Control_L"
  xcape -t 500 -e "Super_L=space"
  xcape -e "Control_L=Escape"
  xcape -e "Shift_R=Delete"
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

# _bluetooth
alias bt=bluetoothctl
function bt-connect() {
  bluetoothctl connect $(bluetoothctl devices | fzf | awk '{print $2}')
}
function bt-disconnect() {
  bluetoothctl disconnect $(bluetoothctl devices | fzf | awk '{print $2}')
}
function bt-share() {
  # Get bluetooth device MAC address
  device=$(bluetoothctl devices | fzf | awk '{print $2}')
  device_path="/org/bluez/hci0/dev_$(echo $device | sed 's/:/_/g')"

  # Create bnep0 network interface
  dbus-send --system --type=method_call --dest=org.bluez $device_path org.bluez.Network1.Connect string:'nap'

  # Connect to new interface
  sudo dhcpcd bnep0
}

## End Aliases

# Projects
export PROJECTS=/home/nglgzz/projects/.utils
source $PROJECTS/config

# Keychain for ssh keys
eval "$(ssh-agent -s)" >>/dev/null

# Android studio vars
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Add downloaded binaries to PATH
export PATH=$PATH:$HOME/.bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# relate autocomplete setup
RELATE_AC_ZSH_SETUP_PATH=/home/nglgzz/.cache/@relate/cli/autocomplete/zsh_setup && test -f $RELATE_AC_ZSH_SETUP_PATH && source $RELATE_AC_ZSH_SETUP_PATH
