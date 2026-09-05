#!/bin/bash -eu

export DENO_INSTALL="$HOME/.local/share/deno"

"$DENO_INSTALL/bin/deno" clean
rm -rf "$DENO_INSTALL" "$HOME/.local/bin/deno" "$ZDOTDIR/completions/_deno.zsh"
