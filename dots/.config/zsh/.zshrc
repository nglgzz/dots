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
source ~/.config/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Preferred terminal and editor for local and remote sessions
export TERM='xterm-256color'
export PATH=$PATH:$HOME/.bin

############################
# ALIASES
# Accepts the name of an associative array with partial names as keys and
# commands as values.
#
# declare -A n_npm=([s]=start [t]=test)
# set_aliases "n_npm"
#
# ns: aliased to npm
# nt: aliased to npm
function set_aliases() {
  local _alias=$(cut -d'_' -s -f1 <<<"$1")
  local _command=$(cut -d'_' -s -f2 <<<"$1")
  local arr=$(declare -p "$1")

  # Arrays declared in functions are local by default
  # https://stackoverflow.com/questions/10806357/associative-arrays-are-local-by-default
  declare -A aliases
  eval "aliases="${arr#*=}

  if [[ -z "$aliases" ]]; then
    return
  fi

  # If the array name doesn't contain the "_" delimiter, this part is skipped.
  if [[ ! -z "$_alias" ]]; then
    alias $_alias=$_command
    # which $_alias

    for k in "${(@k)aliases}"; do
      name="$_alias$k"
      unalias $name 2>/dev/null
      alias $name="$_command ${aliases[$k]}"
      # which $name
    done
  else
    for k in "${(@k)aliases}"; do
      unalias $k 2>/dev/null
      alias $k="${aliases[$k]}"
      # which $k
    done
  fi
}

# Source alias files and set the aliases defined in them
for file in $ZDOTDIR/aliases/*; do
  source "$file"
done

set_aliases "n_npm"
set_aliases "y_yarn"
set_aliases "g_git"
set_aliases "d_docker"
set_aliases "s_systemctl"
set_aliases "bt_bluetoothctl"
set_aliases "keyboard"
set_aliases "projects"
set_aliases "shell"
#
# END ALIASES
############################

# Keychain for ssh keys
eval "$(ssh-agent -s)" >>/dev/null

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# relate autocomplete setup
RELATE_AC_ZSH_SETUP_PATH=/home/nglgzz/.cache/@relate/cli/autocomplete/zsh_setup && test -f $RELATE_AC_ZSH_SETUP_PATH && source $RELATE_AC_ZSH_SETUP_PATH
