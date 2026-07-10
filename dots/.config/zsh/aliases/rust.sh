declare -A rust=(
  [cb]='cargo make build'
  [ct]='cargo test'
)

export RUSTUP_HOME="$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"

[[ -d "$CARGO_HOME" ]] && source "$HOME/.local/share/cargo/env"

