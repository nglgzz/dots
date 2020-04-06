declare -A n_npm=(
  [i]=install
  [s]=start
  [t]=test
  [r]=run
  [b]='run build'
)

declare -A y_yarn=(
  [s]=start
  [d]=dev
  [t]=test
  [a]=add
  [b]=build
)

function pj() {
  cat package.json | jq .$1
}

# Load nvm if there's an .nvmrc or package.json files in the current directory
# and nvm is not already loaded.
load-nvm() {
  if [[ -f .nvmrc || -f package.json ]] && ! type nvm >/dev/null; then
    export NVM_DIR="$HOME/.nvm"
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  fi
}
add-zsh-hook chpwd load-nvm
