declare -A docker=(
  [d]='docker'
  [db]='docker build . -t'
  [dlog]='docker logs $(dfind)'
  [dkill]='docker kill $(dfind)'
  [dsh]='docker exec -it $(dfind) /bin/bash'
  [drmi]='docker rmi $(paste | awk '\''{print $3}'\'')'
  [dfind]='docker ps | tail -n +2 | fzf | awk '\''{print $1}'\'''
  [dvol]='docker-volume'
)

# Runs the specified image (node if none is specified) with a volume mounted at
# the current working directory. The container will stop automatically after 24
# hours.
function docker-volume() {
  docker run --rm -it \
    -v $(pwd):$(pwd) \
    --workdir $(pwd) \
    ${1:-node} \
    /bin/sleep 86400
}
