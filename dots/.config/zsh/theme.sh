#!/usr/bin/zsh
############################
# PROMPT
# Set up the prompt (with git branch name)
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%B%F{green}[%n]%f %2~ $(git_prompt)»%b '
RPROMPT='$(parse_git_origin_sync)%F{#666}[exit %?]%f'

function git_prompt() {
  local ref
  ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
    FLAGS+=('--untracked-files=no')
  fi
  case "$GIT_STATUS_IGNORE_SUBMODULES" in
  git)
    # let git decide (this respects per-repo config in .gitmodules)
    ;;
  *)
    # if unset: ignore dirty submodules
    # other values are passed to --ignore-submodules
    FLAGS+=("--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}")
    ;;
  esac
  STATUS=$(command git status "${FLAGS[@]}" 2>/dev/null | tail -n1)
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

function parse_git_origin_sync() {
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) || return 0
  local upstream="origin/$branch"
  command git rev-parse "$upstream" >/dev/null 2>&1 || return 0
  local count
  count=$(command git rev-list --left-right --count "HEAD...$upstream" 2>/dev/null) || return 0

  local ahead behind
  read -r ahead behind <<<"$count"

  if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
    echo "%F{yellow}[● origin]%f"
  elif [[ "$ahead" -gt 0 ]]; then
    echo "%F{yellow}[⇉ origin]%f"
  elif [[ "$behind" -gt 0 ]]; then
    echo "%F{red}%B[⇇ origin]%b%f"
  else
    echo "%F{blue}[✔ origin]%f"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%B["
ZSH_THEME_GIT_PROMPT_SUFFIX="%B]%b%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red} ●%f%B"
ZSH_THEME_GIT_PROMPT_CLEAN=""

############################
# TITLE BAR
function chpwd() {
  local window_title
  window_title="[$(whoami)]  "$(pwd | sed "s|$HOME|~|")
  echo -ne "\033]0;$window_title\007"
}
chpwd

############################
# COMPLETION
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'

# Add completions directory to search path
if [[ ":$FPATH:" != *":$ZDOTDIR/completions:"* ]]; then
  export FPATH="$ZDOTDIR/completions:$FPATH"
fi

# Needed to load zsh's completion system
autoload -Uz compinit && compinit

## CD if a path is not an executable
setopt AUTO_CD

# https://github.com/zsh-users/zsh-autosuggestions
source "$ZDOTDIR"/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable search of command history with fzf
eval "$(fzf --zsh)"

############################
# HISTORY
export HISTFILE=$ZSH_CACHE_DIR/zsh_history # Where to save history to disk
export HISTSIZE=5000                       # How many lines of history to keep in memory
export SAVEHIST=5000                       # Number of history entries to save to disk

# Don't save duplicate entries in history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

setopt appendhistory    # Append history to the history file (no overwriting)
setopt sharehistory     # Share history across terminals
setopt incappendhistory # Immediately append to the history file, not just when a term is killed

############################
# NAVIGATION
# Make cd automatically call pushd, cd -n will go back to the n position
# in the directories stack, and =n will substitute the path from n
# position in the directories stack.
setopt autopushd pushdminus pushdsilent pushdtohome

############################
# BINDINGS
export WORDCHARS=${WORDCHARS/\//}

bindkey -e
bindkey "^H" backward-kill-word
bindkey "\e[3;5~" kill-word
bindkey "\e[3~" delete-char

bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

# ctrl+o search and edit file
fzf_vim() {
  file=$(find "$(pwd)" -type f -not -path '**/.git/**' -not -path '**/node_modules/**' 2>/dev/null | fzf)
  if [[ -f "$file" ]]; then
    nvim "$file"
  fi
}
zle -N fzf_vim
bindkey "^O" fzf_vim

# ctrl+p search and cat file
fzf_cat() {
  file=$(find "$(pwd)" -type f -not -path '**/.git/**' -not -path '**/node_modules/**' 2>/dev/null | fzf)
  if [[ -f "$file" ]]; then
    bat "$file"
  fi
}
zle -N fzf_cat
bindkey "^P" fzf_cat

# ctrl+f search text in folder
# find_in_folder() {
#   search_term=$(echo "" | fzf --bind "enter:accept-or-print-query" --prompt "search: ")
#   if [[ ! "$search_term" == "" ]]; then
#     rg --max-depth 1 --hidden --json -C 2 "$search_term" | delta
#   fi
# }
# zle -N find_in_folder
# bindkey "^F" find_in_folder

# ctrl+f search text recursively
find_in_folder_rec() {
  search_term=$(echo "" | fzf --bind "enter:accept-or-print-query" --prompt "search (recursive): ")
  if [[ ! "$search_term" == "" ]]; then
    rg --hidden --json -C 2 "$search_term" | delta
  fi
}
zle -N find_in_folder_rec
bindkey "^F" find_in_folder_rec

