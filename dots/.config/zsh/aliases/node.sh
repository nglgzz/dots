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
