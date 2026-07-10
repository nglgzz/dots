declare -A docker=(
  [d]='podman'
  [dc]='podman-compose'

  # Keep aliases the same, but switch between docker and podman.
  [d-docker]='alias d=docker && alias dc='\''docker compose'\'''
  [d-podman]='alias d=podman && alias dc=podman-compose'

  [drun]='d run --rm -it'
  [dvol]='docker-volume'

  [dfind]='d ps | tail -n +2 | fzf | awk '\''{print $1}'\'''
  [dsh]='d exec -it $(dfind) /bin/bash'
  [dzh]='d exec -it $(dfind) /bin/zsh'
  [dlog]='d logs $(dfind)'
  [dkill]='d kill $(dfind)'
)

# Runs a bash shell from the specified image (node if none is specified)
# with a volume mounted at the current working directory.
# The container will stop automatically after you exit the shell.
function docker-volume() {
  docker run --rm -it \
    --volume "$(pwd):$(pwd):rw,Z" \
    --workdir "$(pwd)" \
    --net host \
    "${1:-node}" \
    /bin/bash
}
