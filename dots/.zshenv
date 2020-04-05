export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export XDG_CACHE_HOME=~/.cache
export PROJECTS_HOME=~/projects

export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
export HISTFILE=$ZSH_CACHE_DIR/zsh_history

HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

export EDITOR=nvim
