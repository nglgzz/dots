export KEYBOARD_HOME="$PROJECTS_HOME/nglgzz/42"

declare -A keyboard=(
  [kb]=setxkbmap
  [42]='cd $KEYBOARD_HOME'
  [42source]='cd $KEYBOARD_HOME/firmware && make'
  [42edit]='nvim $KEYBOARD_HOME/firmware/42/keymaps/default/keymap.c'
  ['xev-clean']='xev | awk -F'\''[ )]+'\'' '\''/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'\'''
  [kb-id]='get_xinput_id'
  [kb-enable]='enable_laptop_keyboard'
  [kb-disable]='disable_laptop_keyboard'
)

function get_xinput_id() {
  xinput list | grep $1 | grep -oP '(?<=id=)\d+'
}

function enable_laptop_keyboard() {
  local keyboard_id=$(get_xinput_id 'Virtual core keyboard')
  xinput reattach $(get_xinput_id 'AT Translated Set 2 keyboard') $keyboard_id

  local mouse_id=$(get_xinput_id 'Virtual core pointer')
  xinput reattach $(get_xinput_id TrackPoint) $mouse_id
}

function disable_laptop_keyboard() {
  xinput float $(get_xinput_id TrackPoint)
  xinput float $(get_xinput_id 'AT Translated Set 2 keyboard')
}

# If for some reason I'm not using my keyboard, this makes the most important
# bindings available to the standard keyboard using xmodmap.
function en() {
  setxkbmap us,it,se
  xmodmap ~/.config/xmodmap/xmodmaprc

  pkill xcape

  xmodmap -e "clear Lock"
  xmodmap -e "add Control = Control_L"
  xcape -t 500 -e "Super_L=space"
  xcape -e "Control_L=Escape"
  xcape -e "Shift_R=Delete"
}
