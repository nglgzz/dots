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

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
