declare -A s_systemctl=(
  [start]='start'
  [stop]='stop'
  [restart]='restart'
  [status]='status'
  [reload]='daemon-reload'
)

alias slog='journalctl -f -u'
