declare -A git=(
  [g]='git'
  [gs]='git status'
  [ga]='git add'
  [gd]='git diff'
  [gdd]='git diff HEAD'
  [gddd]='git diff HEAD^1 HEAD'
  [gp]='git pull'
  [gg]='git push origin $(git_current_branch)'
  [ggwp]='git push --force-with-lease origin $(git_current_branch)'
  [go]='git checkout'
  [gb]='git branch'
  [gf]='git fetch'
  [gl]='git ls'
  [gls]='git log --oneline | fzf'
  [gcff]='git rebase --interactive --autosquash HEAD~10'
  [gca]='git commit --amend'
  [gcaa]='git commit --amend --no-edit'
  [gu]='git fetch upstream && git rebase upstream/master'
)

function gcf() {
  commit=$(git ls | head -n10 | fzf | grep -oP '\[\K\w{7}(?=])')
  git commit --fixup $commit
}

function gc() {
  arg="$*"
  git commit -m "$arg"
}

git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2>/dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

function git_prompt() {
  local ref
  if [[ "$(command git config --get zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
      ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get zsh.hide-dirty)" != "1" ]]; then
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    case "$GIT_STATUS_IGNORE_SUBMODULES" in
    git)
      # let git decide (this respects per-repo config in .gitmodules)
      ;;
    *)
      # if unset: ignore dirty submodules
      # other values are passed to --ignore-submodules
      FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
      ;;
    esac
    STATUS=$(command git status ${FLAGS} 2>/dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[white]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ●%{$fg[white]%}]%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="]%{$reset_color%} "
