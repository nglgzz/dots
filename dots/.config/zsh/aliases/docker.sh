declare -A docker=(
  [d]='docker'
  [db]='docker build . -t'
  [dlog]='docker logs $(dfind)'
  [dkill]='docker kill $(dfind)'
  [dsh]='docker exec -it $(dfind) /bin/bash'
  [drmi]='docker rmi $(paste | awk '\''{print $3}'\'')'
  [dfind]='docker ps | tail -n +2 | fzf | awk '\''{print $1}'\'''
)
