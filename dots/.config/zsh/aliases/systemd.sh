declare -A systemctl=(
  [s]='systemctl'
  [sstart]='systemctl start'
  [sstop]='systemctl stop'
  [srestart]='systemctl restart'
  [sstatus]='systemctl status'
  [sreload]='systemctl daemon-reload'
)

alias slog='journalctl -f -u'
