#!/bin/bash -eu

export DENO_INSTALL="$HOME/.local/share/deno"
export CI=1

curl -fsSL https://deno.land/install.sh | sh
if [[ -f "$HOME/.local/bin/deno" ]]; then
    rm "$HOME/.local/bin/deno"
fi
ln -s "$DENO_INSTALL/bin/deno" "$HOME/.local/bin/deno"
deno completions zsh > "$ZDOTDIR/completions/_deno.zsh"
