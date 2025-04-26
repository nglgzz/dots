export KEYBOARD_HOME="$PROJECTS_HOME/nglgzz/42"

declare -A keyboard=(
  [42]='cd $KEYBOARD_HOME'
  [42source]='cd $KEYBOARD_HOME/firmware && make'
  [42edit]='code $KEYBOARD_HOME/firmware/keymaps/default/keymap.c'
  ['xev-clean']='xev | awk -F'\''[ )]+'\'' '\''/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'\'''
)
