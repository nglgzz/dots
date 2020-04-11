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
  [gls]='git log --show-signature'
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
