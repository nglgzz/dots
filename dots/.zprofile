# This line starts the X server when logging in. The first part is to avoid the
# "only console users are allowed to run the x server" error on tmux or other
# programs.
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
