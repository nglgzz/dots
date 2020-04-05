############################
# PROMPT
# Set up the prompt (with git branch name)
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%2~ $(git_prompt)»%b '

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

############################
# MISC
# Add custom binaries to path
export PATH=$PATH:$HOME/.bin

# Keychain for ssh keys
eval "$(ssh-agent -s)" >>/dev/null

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# relate autocomplete setup
RELATE_AC_ZSH_SETUP_PATH=/home/nglgzz/.cache/@relate/cli/autocomplete/zsh_setup && test -f $RELATE_AC_ZSH_SETUP_PATH && source $RELATE_AC_ZSH_SETUP_PATH
