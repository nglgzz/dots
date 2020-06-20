declare -A docker=(
  [d]='docker'
  [db]='docker build . -t'
  [dlog]='docker logs $(dfind)'
  [dkill]='docker kill $(dfind)'
  [dsh]='docker exec -it $(dfind) /bin/bash'
  [drmi]='docker rmi $(paste | awk '\''{print $3}'\'')'
  [dfind]='docker ps | tail -n +2 | fzf | awk '\''{print $1}'\'''
  [dvol]='docker-volume'
  [dvolx]='docker-volume-x11'
)

# Runs a bash shell from the specified image (node if none is specified)
# with a volume mounted at the current working directory.
# The container will stop automatically after you exit the shell.
function docker-volume() {
  docker run --rm -it \
    --volume "$(pwd):$(pwd)" \
    --workdir $(pwd) \
    --net host \
    ${1:-node} \
    /bin/bash

}

# Similar to docker-volume, but the default image is ubuntu and it will use the
# host's X server to render GUI applications. For the forwarding to work
# properly you need to run the following command once inside the container:
#    eval $(dbus-launch --sh-syntax)
function docker-volume-x11() {
  xhost +si:localuser:root

  docker run --rm -it \
    --volume "$(pwd):$(pwd)" \
    --volume $HOME/.Xauthority:/.Xauthority \
    --env "XAUTHORITY=/.Xauthority" \
    --env "DISPLAY" \
    --net host \
    --workdir $(pwd) \
    ${1:-ubuntu} \
    /bin/bash # eval $(dbus-launch --sh-syntax)

  xhost -si:localuser:root
}

# Similar to docker-volume-x11, but the forwarding is done through an
# unprivileged user instead of root.
function docker-volume-x11-non-root() {
  local uid=$(id --user)
  local gid=$(id --group)
  local command="
    mkdir -p /home/dev &&
    useradd dev --uid $uid --home /home/dev --shell /bin/bash &&
    chown $uid:$gid -R /home/dev;
    /bin/bash
  "

  docker run --rm -it \
    --volume "$(pwd):$(pwd)" \
    --volume $HOME/.Xauthority:/home/dev/.Xauthority \
    --env "DISPLAY" \
    --net host \
    --workdir $(pwd) \
    ${1:-ubuntu} \
    /bin/sh -c "$command" # eval $(dbus-launch --sh-syntax)
}
