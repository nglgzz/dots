declare -A docker=(
  [d]='docker'
  [db]='docker build . -t'
  [dlog]='docker logs $(dfind)'
  [dkill]='docker kill $(dfind)'
  [dsh]='docker exec -it $(dfind) /bin/bash'
  [drmi]='docker rmi $(paste | awk '\''{print $3}'\'')'
)

function dfind() {
  if [ -z "$1" ]; then
    docker ps | tail -n +2 | fzf | awk '{print $1}'
  else
    docker ps | grep $1 | awk '{print $1}' | head -n1
  fi
}
