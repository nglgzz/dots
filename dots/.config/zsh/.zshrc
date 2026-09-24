source $ZDOTDIR/theme.sh
source $ZDOTDIR/aliases.sh

export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.deno/bin"
export PATH="$PATH:$HOME/go/bin"
export FORCE_COLOR=1

# Sourcing this after in case there are
# overrides to path or aliases.
source $ZDOTDIR/.private

############################
# SSH
#
[[ ! -d ~/.ssh ]] && mkdir "$HOME/.ssh"
[[ ! -f ~/.ssh/config ]] && echo "AddKeysToAgent yes" >>"$HOME/.ssh/config"
eval "$(ssh-agent -s)" >>/dev/null

############################
# Other
#
