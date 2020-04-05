declare -A d_docker=(
  [b]='build . -t'
  [log]='logs $(dfind)'
  [kill]='kill $(dfind)'
  [sh]='exec -it $(dfind) /bin/bash'
  [rmi]='rmi $(paste | awk '\''{print $3}'\'')'
)

function dfind() {
  if [ -z "$1" ]; then
    docker ps | tail -n +2 | fzf | awk '{print $1}'
  else
    docker ps | grep $1 | awk '{print $1}' | head -n1
  fi
}
