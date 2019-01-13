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
plugins=(git)
source $ZSH/oh-my-zsh.sh

# https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Reset aliases that will be overridden later.
unalias gc gca d

# Preferred terminal and editor for local and remote sessions
export TERM='xterm-256color'
export EDITOR='vim'

## Aliases
# _configs
alias zedit='vim ~/.zshrc && source ~/.zshrc'
alias zource='source ~/.zshrc'
alias i3edit='vim ~/.config/i3/config'

# _keyboards
alias 42source='sleep 3 && cd ~/projects/nglgzz/42/firmware && make all && teensy_loader_cli --mcu atmega32u4 42.hex && xev-clean'
alias 42edit='vim ~/projects/nglgzz/42/firmware/keymap_42.c'
alias 42='cd ~/projects/nglgzz/42'

alias 9source='cd ~/projects/nglgzz/qmk_firmware && make 9:default:avrdude && xev-clean'
alias 9edit='vim ~/projects/nglgzz/9/keymaps/default/keymap.c'
alias 9='cd ~/projects/nglgzz/9'

# _bookmarks
alias tmp='cd ~/tmp'
alias ww='pcd whitewalker'
alias wwt='pcd whitewalker && yarn generate && yarn build && yarn test-ci'
alias ngl='pcd nglgzz nglgzz'

# _dev utils
alias cat='bat'
alias _cat='command cat'
alias serve='python -m http.server'
alias e='code .'

v() {
  # find in folder and open on vim
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && vim "${files[@]}"
}

# _shell
alias q='exit'
alias l='ls -ah'
alias ll='ls -lha'
alias copy='xclip -selection clipboard'
alias paste='xclip -out'

function tousb() {
  sudo dd bs=4M if=$1 of=$2 status=progress
}
alias keychain='eval "$(ssh-agent -s)"'

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

export PATH=~/.npm-global/bin:$PATH
# NPM Path (there's probably a better way to do this)
export PATH=$PATH:./node_modules/.bin/

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
alias ga='git add'
alias gp='git pull'
alias gg='git push origin $(current_branch)'
alias go='git checkout'
alias gb='git branch'
alias gf='git fetch'
alias gl='git ls'
alias gca='git commit --amend'
alias ggwp='git push --force-with-lease origin $(current_branch)'

function gc() {
  arg="$*"
  git commit -m "$arg"
}

# _docker
alias d='docker'
alias db='docker build . -t'
alias dc='docker container'
alias de='docker exec -it'

# _curl
function cheat() {
  curl "cheat.sh/$1"
}
alias weather='curl wttr.in/..'

# _systemd
alias s='systemctl'
alias sstart='systemctl start'
alias sstop='systemctl stop'
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

# _aplications
alias vpn='sudo openfortivpn'
alias bt=bluetoothctl
## End Aliases

# Projects
export PROJECTS=/home/nglgzz/projects/.utils
source $PROJECTS/config

# IBus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
