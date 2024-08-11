############################
# ALIASES
# Accepts the name of an associative array with names as keys and commands
# as values.
#
# declare -A npm=([ns]='npm start' [nt]='npm test')
# set_aliases "npm"
#
# ns: aliased to npm start
# nt: aliased to npm test
function set_aliases() {
  local arr=$(declare -p "$1")

  # Arrays declared in functions are local by default
  # https://stackoverflow.com/questions/10806357/associative-arrays-are-local-by-default
  declare -A aliases
  eval "aliases=${arr#*=}"

  if [[ -z "$aliases" ]]; then
    return
  fi

  for k in "${(@k)aliases}"; do
    unalias "$k" 2>/dev/null
    alias "$k"="${aliases[$k]}"
  done
}
function aliases() {
  local arr=$(declare -p "$1")

  declare -A aliases
  eval "aliases=${arr#*=}"

  for k in "${(@k)aliases}"; do
    echo "$(tput bold)$k$(tput sgr0) \t= $(tput dim)${aliases[$k]}$(tput sgr0)"
  done | column -t -s $'\t'
}

# Source alias files and set the aliases defined in them
for file in $ZDOTDIR/aliases/*; do
  source "$file"
done

set_aliases "npm"
set_aliases "pnpm"
set_aliases "yarn"
set_aliases "deno"
set_aliases "git"
set_aliases "docker"
set_aliases "systemctl"
set_aliases "bluetoothctl"
set_aliases "keyboard"
set_aliases "projects"
set_aliases "shell"
set_aliases "rust"
