source $ZDOTDIR/theme.sh
source $ZDOTDIR/aliases.sh

export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.bin/extra"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"

############################
# MISC
# Keychain for ssh keys
[[ ! -f ~/.ssh/config ]] && echo "AddKeysToAgent yes" >>$HOME/.ssh/config
eval "$(ssh-agent -s)" >>/dev/null

# relate autocomplete
RELATE_AUTOCOMPLETE=$XDG_CACHE_HOME/@relate/cli/autocomplete/zsh_setup &&
  test -f $RELATE_AUTOCOMPLETE &&
  source $RELATE_AUTOCOMPLETE

export FORCE_COLOR=1
