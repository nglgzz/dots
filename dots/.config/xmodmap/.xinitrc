setxkbmap it
xmodmap ~/.xmodmaprc

# xmodmap is so shit that these two lines won't work if I put them in the
#  .xmodmaprc but here they are completely fine
xmodmap -e "clear Lock"
xmodmap -e "add Control = Control_L"

xcape -e "Super_L=space"
xcape -e "Control_L=Escape"
xcape -e "Mode_switch=Tab"

xset -b

exec i3

