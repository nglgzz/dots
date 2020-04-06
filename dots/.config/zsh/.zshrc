############################
# PROMPT
# Set up the prompt (with git branch name)
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%2~ $(git_prompt)»%b '

############################
# COMPLETION
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# https://github.com/zsh-users/zsh-autosuggestions
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh

############################
# BINDINGS
bindkey -e
bindkey "^H" backward-kill-word
bindkey "\e[3;5~" kill-word
bindkey "\e[3~" delete-char

bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

############################
# ALIASES
# Accepts the name of an associative array with names as keys and commands
# as values.
#
# declare -A npm=([ns]=start [nt]=test)
# set_aliases "npm"
#
# ns: aliased to npm
# nt: aliased to npm
function set_aliases() {
  local arr=$(declare -p "$1")

  # Arrays declared in functions are local by default
  # https://stackoverflow.com/questions/10806357/associative-arrays-are-local-by-default
  declare -A aliases
  eval "aliases="${arr#*=}

  if [[ -z "$aliases" ]]; then
    return
  fi

  for k in "${(@k)aliases}"; do
    unalias $k 2>/dev/null
    alias $k="${aliases[$k]}"
  done
}
function aliases() {
  local arr=$(declare -p "$1")

  declare -A aliases
  eval "aliases="${arr#*=}

  for k in "${(@k)aliases}"; do
    echo "$(tput bold)$k$(tput sgr0) \t= $(tput dim)${aliases[$k]}$(tput sgr0)"
  done | column -t -s $'\t'
}

# Source alias files and set the aliases defined in them
for file in $ZDOTDIR/aliases/*; do
  source "$file"
done

set_aliases "npm"
set_aliases "yarn"
set_aliases "git"
set_aliases "docker"
set_aliases "systemctl"
set_aliases "bluetoothctl"
set_aliases "keyboard"
set_aliases "projects"
set_aliases "shell"

############################
# MISC
# Add custom binaries to path
export PATH=$PATH:$HOME/.bin

# Keychain for ssh keys
eval "$(ssh-agent -s)" >>/dev/null

# relate autocomplete setup
RELATE_AC_ZSH_SETUP_PATH=/home/nglgzz/.cache/@relate/cli/autocomplete/zsh_setup && test -f $RELATE_AC_ZSH_SETUP_PATH && source $RELATE_AC_ZSH_SETUP_PATH
