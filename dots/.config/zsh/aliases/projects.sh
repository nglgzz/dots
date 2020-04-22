# This file depends on the .bin/find_project script.
declare -A projects=(
  [pfind]=find_project
  [ptest]=project_test
  [pbuild]=project_build
)

function pcd() {
  if [[ -z "$1" ]]; then
    source <(echo "cd $PROJECTS_HOME")
    return
  fi

  local project_path=$(find_project $1)
  if [[ -d "$project_path" ]]; then
    source <(echo "cd $project_path")
  else
    echo "project not found: $1"
  fi
}

function project_test() {
  local prev_wd=$(pwd)
  pcd $1
  npm test
  source <(echo "cd $prev_wd")
}

function project_build() {
  local prev_wd=$(pwd)
  pcd $1
  npm run build
  source <(echo "cd $prev_wd")
}
