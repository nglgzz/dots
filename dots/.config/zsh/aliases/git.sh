declare -A g_git=(
  [s]=status
  [a]=add
  [d]=diff
  [dd]='diff HEAD'
  [ddd]='diff HEAD^1 HEAD'
  [p]=pull
  [g]='push origin $(current_branch)'
  [wp]='push --force-with-lease origin $(current_branch)'
  [o]=checkout
  [b]=branch
  [f]=fetch
  [l]=ls
  [ls]='log --oneline | fzf'
  [cff]='rebase --interactive --autosquash HEAD~10'
  [ca]='commit --amend'
  [caa]='commit --amend --no-edit'
  [u]='fetch upstream && git rebase upstream/master'
  [grls]='log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"- [%Cblue%h%Creset] %s"'
)

function gcf() {
  commit=$(git ls | head -n10 | fzf | grep -oP '\[\K\w{7}(?=])')
  git commit --fixup $commit
}

function gc() {
  arg="$*"
  git commit -m "$arg"
}
