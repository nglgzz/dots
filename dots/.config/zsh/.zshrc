source $ZDOTDIR/theme.sh
source $ZDOTDIR/aliases.sh
export PATH=$PATH:$HOME/.bin

############################
# MISC
# Keychain for ssh keys
[[ ! -f ~/.ssh/config ]] && echo "AddKeysToAgent yes" >>$HOME/.ssh/config
eval "$(ssh-agent -s)" >>/dev/null

# relate autocomplete
RELATE_AC_ZSH_SETUP_PATH=$XDG_CACHE_HOME/@relate/cli/autocomplete/zsh_setup &&
  test -f $RELATE_AC_ZSH_SETUP_PATH &&
  source $RELATE_AC_ZSH_SETUP_PATH
