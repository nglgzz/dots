source $ZDOTDIR/theme.sh
source $ZDOTDIR/aliases.sh
source $ZDOTDIR/.private

export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.bin/extra"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export FORCE_COLOR=1

############################
# MISC
# Keychain for ssh keys
[[ ! -d ~/.ssh ]] && mkdir "$HOME/.ssh"
[[ ! -f ~/.ssh/config ]] && echo "AddKeysToAgent yes" >>"$HOME/.ssh/config"
eval "$(ssh-agent -s)" >>/dev/null

# Used when unlocking GPG keys
export GPG_TTY=$(tty)
