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
unalias gc gca d grb

# Preferred terminal and editor for local and remote sessions
export TERM='xterm-256color'
export EDITOR='vim'

## Aliases
# _configs
alias zedit='vim ~/.zshrc && source ~/.zshrc'
alias zource='source ~/.zshrc'
alias i3edit='vim ~/.config/i3/config'

# _keyboards
alias 42source='cd ~/projects/nglgzz/qmk_fimware/ && make handwired/42:default:avrdude'
alias 42edit='vim ~/projects/nglgzz/qmk_firmware/keyboards/handwired/42/keymaps/default/keymap.c'
alias 42='cd ~/projects/nglgzz/42/'

alias 16source='cd ~/projects/nglgzz/16/ && make'
alias 16edit='vim ~/projects/nglgzz/16/keymaps/default/keymap.c'
alias 16='cd ~/projects/nglgzz/16'

# _bookmarks
alias tmp='cd ~/tmp'
alias ww='pcd whitewalker'
alias ngl='pcd nglgzz nglgzz'

# _dev utils
alias cat='bat'
alias _cat='command cat'
alias serve='python -m http.server'
alias e='code .'

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

export PATH=$PATH:~/.npm-global/bin
source /usr/share/nvm/init-nvm.sh

# _yarn
alias y='yarn'
alias ys='yarn start'
alias yd='yarn dev'
alias yt='yarn test-ci'
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
alias gcf='git commit --fixup'
alias gcff='git rebase --interactive --autosquash --root'
alias gca='git commit --amend'
alias gcaa='git commit --amend --no-edit'
alias grb='git rebase origin/master'
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
  docker exec -it $(dfind $1) /bin/sh
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

alias xev-clean='xev | awk -F'\''[ )]+'\'' '\''/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'\'''

# 10 most used commands, can show more or less appending "-n15" for example
alias topten='history | awk '\''{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10'

# Upload a file on transfer.sh and copy link to that file on the clipboard
function share() {
  if [ $# -eq 0 ]; then
    echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
    return 1
  fi

  tmpfile=$( mktemp -t transferXXX )

  if tty -s; then
    basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
    curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
  else
    curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile
  fi

  cat $tmpfile
  cat $tmpfile | copy
  rm -f $tmpfile
}

function en () {
 setxkbmap us
 xmodmap ~/.xmodmaprc
 pkill xcape
 xmodmap -e "clear Lock"
 xmodmap -e "add Control = Control_L"
 xcape -t 500 -e "Super_L=space"
 xcape -e "Control_L=Escape"
 xcape -e "Shift_R=Delete"
}

function it () {
 setxkbmap it
 xmodmap ~/.xmodmaprc
 pkill xcape
 xmodmap -e "clear Lock"
 xmodmap -e "add Control = Control_L"
 xcape -t 500 -e "Super_L=space"
 xcape -e "Control_L=Escape"
 xcape -e "Shift_R=Delete"
}

# Mount LUKS encrypted device
function emnt () {
  sudo cryptsetup open "/dev/$1" "crypt_$1"
  sudo mount "/dev/mapper/crypt_$1" $2
}

# Unmount LUKS encrypted device
function eumount () {
  sudo umount $1
  sudo cryptsetup close "crypt_$2"
}

# _aplications
alias vpn='sudo openfortivpn'
alias bt=bluetoothctl
## End Aliases

# Projects
export PROJECTS=/home/nglgzz/projects/.utils
source $PROJECTS/config

# Keychain for ssh keys
eval "$(ssh-agent -s)" >> /dev/null

# Android studio vars
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Add downloaded binaries to PATH
export PATH=$PATH:$HOME/.bin
