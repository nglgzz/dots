# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred terminal and editor for local and remote sessions
export TERM='xterm-256color'
export EDITOR='vim'

## Aliases
# _configs
alias zource='source ~/.zshrc'
alias zedit='vim ~/.zshrc'
alias kbsource='make all && teensy_loader_cli --mcu at90usb1286 gh60_lufa.hex && xev-clean'


# _bookmarks
alias down='cd ~/downloads'
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
alias l='ls -lah'
alias la='ls -ah'
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
alias elasticsearch='~/bin/elasticsearch/bin/elasticsearch'
alias kibana='~/bin/kibana/bin/kibana'
alias chatty='java -jar ~/bin/chatty/Chatty.jar'
alias memcached='systemctl restart memcached && journalctl -u memcached -f'
alias neo4j='/home/mnbv/bin/neo4j/bin/neo4j'


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

# _streaming
alias twitch='systemctl start --user twitch-local-commands'
alias twitch-stop='systemctl stop --user twitch-local-commands'

# Assumes that chromix-too-server is running, and prints the link of all YouTube tabs open.
alias tune='chromix-too ls | grep youtube | cut -f 1 -d '\'' '\'' --complement | sed '\''s/ - YouTube//'\'' | sed '\''s/ /\n🔊 /'\'' | sort -r'

# Change the url of the first tab playing music on  Youtube.
function play() {
  tab=$(chromix-too ls | grep youtube | head -n1 | cut -f 1 -d ' ')

  chromix-too raw 'chrome.tabs.update' $tab '{"url": "'$1'"}'
}

# Skip to the next song on the first tab playing music on Youtube.
function skip() {
  tab=$(chromix-too ls | grep youtube | head -n1 | cut -f 1 -d ' ')

  chromix-too raw 'chrome.tabs.executeScript' $tab '{"code": "document.querySelector(\".ytp-next-button\").click();"}'
}

# _random
# In case there's no WiFi and I have internet access via cable, I can create an
# access point so I can share the connection with my phone.
alias lettherebewifi="sudo create_ap wlp3s0 enp0s25 'Gluten-Free Fair Trade WiFi' ALLLOWERCASEWITHSPACES"

alias xev-clean='xev | awk -F'\''[ )]+'\'' '\''/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'\'''


# 10 most used commands, can show more or less appending "-n15" for example
alias topten='history | awk '\''{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10'

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
