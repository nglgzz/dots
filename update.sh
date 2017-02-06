echo '#  updating i3 style'
cp ./dots/i3/* .i3/

echo '#  updating terminator style'
cp ./dots/terminator/config .config/terminator/

echo '#  updating gtk style'
cp ./dots/gtk-3.0/settings.ini .config/gtk-3.0/

echo '#  updating sublime settings'
cp ./dots/sublime-text-3/* .config/sublime-text-3/Packages/User/

echo '#  done, restart i3 to show changes'
