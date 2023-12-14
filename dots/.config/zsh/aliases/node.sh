declare -A npm=(
  [n]='corepack npm'
  [ni]='corepack npm install'
  [ns]='corepack npm start'
  [nt]='corepack npm test'
  [nr]='corepack npm run'
  [nb]='corepack npm run build'
  [ncirculars]="npx dpdm --warning false --circular -T --exclude 'node_modules/.*' src"
)

declare -A pnpm=(
  [p]='corepack pnpm'
  [pi]='corepack pnpm install'
  [ps]='corepack pnpm start'
  [pt]='corepack pnpm test'
  [pr]='corepack pnpm run'
  [pb]='corepack pnpm run build'
)

declare -A yarn=(
  [y]='corepack yarn'
  [ys]='corepack yarn start'
  [yd]='corepack yarn dev'
  [yt]='corepack yarn test'
  [ya]='corepack yarn add'
  [yb]='corepack yarn build'
  [yaf]='yarn-audit-fix'
)

function pj() {
  jq ."$1" package.json
}

# https://dev.to/antongolub/yarn-audit-fix-workaround-i2a
function yarn-audit-fix {
  npx synp --source-file yarn.lock
  npm audit fix
  rm yarn.lock
  yarn import
  rm package-lock.json
}

source /usr/share/nvm/init-nvm.sh
