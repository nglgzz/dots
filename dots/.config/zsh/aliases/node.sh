declare -A npm=(
  [n]='npm'
  [ni]='npm install'
  [ns]='npm start'
  [nt]='npm test'
  [nr]='npm run'
  [nb]='npm run build'
  [ncirculars]="dpdm --warning false --circular -T --exclude 'node_modules/.*' src"
)

declare -A yarn=(
  [y]='yarn'
  [ys]='yarn start'
  [yd]='yarn dev'
  [yt]='yarn test'
  [ya]='yarn add'
  [yb]='yarn build'
  [yaf]='yarn-audit-fix'
)

function pj() {
  cat package.json | jq .$1
}

# https://dev.to/antongolub/yarn-audit-fix-workaround-i2a
function yarn-audit-fix {
  npx synp --source-file yarn.lock
  npm audit fix
  rm yarn.lock
  yarn import
  rm package-lock.json
}

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
