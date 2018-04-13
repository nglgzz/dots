# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="agnoster"
#ZSH_THEME="gallois"
ZSH_THEME="minimal"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred terminal and editor for local and remote sessions
export TERM='xterm-256color'
export EDITOR='vim'

## Aliases
# _configs
alias zource='source ~/.zshrc'
alias zedit='vim ~/.zshrc'
alias scompletions='vim ~/dots/dots/.config/sublime-text-3/javascript.sublime-completions'

# _keyboards
alias 42source='cd ~/projects/nglgzz/42/firmware && make all && teensy_loader_cli --mcu atmega32u4 42.hex && xev-clean'
alias 42edit='vim ~/projects/nglgzz/42/firmware/keymap_42.c'
alias 42='cd ~/projects/nglgzz/42'

alias 9source='cd ~/projects/nglgzz/9/firmware && make all && teensy_loader_cli --mcu at90usb1286 9.hex && xev-clean'
alias 9edit='vim ~/projects/nglgzz/9/firmware/keymap_9.c'
alias 9='cd ~/projects/nglgzz/9'

# _bookmarks
alias tmp='cd ~/tmp'


# _dev utils
alias serve='python -m http.server'
alias e='subl .'

v() {
  # find in folder and open on vim
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && vim "${files[@]}"
}


# _shell
alias q='exit'
alias l='ls -ah'
alias la='ls -lah'
alias ll='ls -lh'
alias lla='ls -lah'
alias copy='xclip -selection clipboard'
alias f='find . -name'
function c() {
  cf_path=$(find . -name "$1" | head  -n1)
  cd $cf_path
}
function md() {
  mkdir -p "$1"
  cd "$1"
}
function tousb() {
  dd bs=4M if=$1 of=$2
}

# _navigation
alias b='popd 1>/dev/null'

# _tmux
function tm() {
  # split window in 4 panes like below
  #  ---------
  # |    |    |
  # |----|----|
  # |    |    |
  #  ---------
  tmux new-session
  tmux splitp -h
  tmux splitp -v
  tmux selectp -t 0
  tmux splitp -v
}


# _npm
alias n='npm'
alias ni='npm install'
alias ns='npm start'
alias nb='npm run build'
alias nr='npm run'
alias nt='npm test'
alias ntw='npm run test:watch'

export PATH=~/.npm-global/bin:$PATH
# NPM Path (there's probably a better way to do this)
export PATH=$PATH:./node_modules/.bin/


# _git
alias g='git'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gp='git pull'
alias gg='git push'
alias go='git checkout'
alias gb='git branch'
alias gf='git fetch'
alias gl='git ls'

function gc() {
  arg="$*"
  git commit -m "$arg"
}


# _docker
alias d='docker'
alias dc='docker-compose'


# _learn-anything
alias learn='cd $(pfind learn-anything)/learn-anything'


# _launchers
# TODO - should just add ~/bin to path and link the executables
# to launch these programs there
alias dynamodb='cd ~/bin/dynamodb && java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb'
alias elasticsearch='~/bin/elasticsearch-5.5.2/bin/elasticsearch'
alias kibana='~/bin/kibana/bin/kibana'
alias chatty='java -jar ~/bin/chatty/Chatty.jar'
alias memcached='systemctl restart memcached && journalctl -u memcached -f'
alias neo4j='~/bin/neo4j/bin/neo4j'


# _albert
alias alog='journalctl -u albert --user -f'
alias ares='systemctl --user restart albert'
alias al='cd ~/.local/share/albert/org.albert.extension.python/modules'


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

# _testing
alias memc='telnet localhost 11211'

function loc() {
  if [[ -z "$1" ]]; then
    chromium "http://localhost:3000"
    exit
  fi

  if [[ 1 == "${#1}" ]]; then
    chromium "http://localhost:${1}000"
    exit
  fi

  chromium "http://localhost:$1"
}

# _streaming
alias twitch='systemctl start --user twitch-local-commands'
alias twitch-stop='systemctl stop --user twitch-local-commands'
alias twitch-local='systemctl --user set-environment TWITCH_HOST=localhost && twitch && systemctl --user unset-environment TWITCH_HOST'

# Assumes that chromix-too-server is running, and prints the link of all YouTube tabs open.
alias song='chromix-too ls | grep youtube | cut -f 1 -d '\'' '\'' --complement | sed '\''s/ - YouTube//'\'' | sed '\''s/ /\n🔊 /'\'' | sort -r'

# Change the url of the first tab playing music on  Youtube.
function play() {
  curl "http://localhost:8268/change?url=$1"
}

# Skip to the next song on the first tab playing music on Youtube.
function nextsong() {
  tab=$(chromix-too ls | grep youtube | head -n1 | cut -f 1 -d ' ')

  chromix-too raw 'chrome.tabs.executeScript' $tab '{"code": "document.querySelector(\".ytp-next-button\").click();"}'
}

function playpause() {
  tab=$(chromix-too ls | grep youtube | head -n1 | cut -f 1 -d ' ')

  chromix-too raw 'chrome.tabs.executeScript' $tab '{"code": "document.querySelector(\".ytp-play-button\").click();"}'
}

# _random
# In case there's no WiFi and I have internet access via cable, I can create an
# access point so I can share the connection with my phone.
alias lettherebewifi="sudo create_ap wlp3s0 enp0s25 'Gluten-Free Fair Trade WiFi' ALLLOWERCASEWITHSPACES"

alias xev-clean='xev | awk -F'\''[ )]+'\'' '\''/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'\'''

alias random-word='cat /usr/share/dict/cracklib-small | grep -Pv '\''[^a-z]|([a-z])\1'\'' | shuf -n1'
alias random-song='curl "http://musicbrainz.org/ws/2/work?query=$(random-word | cut -c1-4)&fmt=json" -s | node tmp/random/index.js'

# 10 most used commands, can show more or less appending "-n15" for example
alias topten='history | awk '\''{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10'

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

function it() {
  setxkbmap it
  xmodmap ~/.xmodmaprc
  pkill xcape
  xcape -e "Super_L=space"
  xcape -e "Control_L=Escape"
  xcape -e "Mode_switch=Tab"
}

function en() {
  setxkbmap us
  xmodmap ~/.xmodmaprc
  pkill xcape
  xcape -e "Super_L=space"
  xcape -e "Control_L=Escape"
  xcape -e "Mode_switch=Tab"
}

function journal() {
  # create journal entries
  year=$(date | awk '{print $6}')
  month=$(date | awk '{print $2}')
  datetime=$(date | awk '{print $3 "\t" $4 "\t" $5}')
  out="$(pfind journal)/$year/$month"

  log="$*"

  echo $datetime >> $out
  echo $log >> $out
  echo '' >> $out
}
HISTORY_IGNORE='journal *'
## End Aliases

# Projects
export PROJECTS=$HOME/projects/.utils
source $PROJECTS/config
