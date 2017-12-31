setxkbmap us
xmodmap ~/.xmodmaprc

# I'm not sure why, but the two lines below won't work if I put them in
# the .xmodmaprc file, but here work fine ¯\_(ツ)_/¯.
xmodmap -e "clear Lock"
xmodmap -e "add Control = Control_L"

xcape -e "Super_L=space"
xcape -e "Control_L=Escape"
xcape -e "Mode_switch=Tab"

# Disable the annoying beep on the laptop.
xset -b

exec i3
