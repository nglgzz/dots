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
  [pe]='pnpm-run'
  [px]='pnpm-run'
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

declare -A deno=(
  [d]='deno'
  [ds]='deno task start'
  [db]='deno task build'
  [dl]='deno lint'
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

function pnpm-run {
  pnpm_script=$(jq -r '.scripts | to_entries[] | "\(input_filename){}\(.key){} \(.value)"' **/package.json | column -ts {} | fzf)

  script_package_json=$(awk '{ print $1 }' <<<$pnpm_script)
  script_dir=$(dirname $script_package_json)
  script_name=$(awk '{ print $2 }' <<<$pnpm_script)

  echo "Running [$script_name] from [$script_dir]"
  corepack pnpm run --dir $script_dir $script_name
}

source /usr/share/nvm/init-nvm.sh
