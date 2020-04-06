declare -A npm=(
  [n]='npm'
  [ni]='npm install'
  [ns]='npm start'
  [nt]='npm test'
  [nr]='npm run'
  [nb]='npm run build'
)

declare -A yarn=(
  [y]='yarn'
  [ys]='yarn start'
  [yd]='yarn dev'
  [yt]='yarn test'
  [ya]='yarn add'
  [yb]='yarn build'
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
