# This file depends on the .bin/project-find script.
declare -A projects=(
  [pfind]=project-find
  [pstart]=project_npm_start
  [pbuild]=project_npm_run_build
  [ptest]=project_npm_test
)

function pcd() {
  if [[ -z "$1" ]]; then
    source <(echo "cd $PROJECTS_HOME")
    return
  fi

  local project_path=$(project-find "$1")
  if [[ -d "$project_path" ]]; then
    source <(echo "cd $project_path")
  else
    echo "project not found: $1"
  fi
}

function project_npm_start() {
  local prev_wd=$(pwd)
  pcd "$1"
  npm start
}

function project_npm_test() {
  local prev_wd=$(pwd)
  pcd "$1"
  npm test
  source <(echo "cd $prev_wd")
}

function project_npm_run_build() {
  local prev_wd=$(pwd)

  for project in "$@"; do
    pcd "$project"
    npm run build
  done

  source <(echo "cd $prev_wd")
}
