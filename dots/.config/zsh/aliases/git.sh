declare -A git=(
  [g]='git'
  [gno]='git restore --staged'
  [gs]='git status'
  [ga]='git add'
  [gd]='git diff'
  [gdd]='git diff --staged'
  [gddd]='git diff HEAD^1 HEAD'
  [gsn]='git show --name-only'
  [gp]='git pull'
  [gg]='git push origin $(git_current_branch)'
  [ggwp]='git push --force-with-lease origin $(git_current_branch)'
  [go]='git checkout'
  [gb]='git branch'
  [gf]='git fetch'
  [gl]='git ls'
  [gls]='git log --show-signature'
  [gcf]='git-commit-fixup'
  [gcff]='git-commit-fixup-autosquash'
  [gca]='git commit --amend'
  [gcaa]='git commit --amend --no-edit'
  [gu]='git fetch upstream && git rebase upstream'
  [grls]='git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"- [%Cblue%h%Creset] %s"'
  [grls-nochore]='grls | grep -vwi "chore"'
  [ghpr]="github-pr-open"
  [gha]="github-pr-assigned"
  [ghco]="github-pr-checkout"
)


function git-commit-fixup-autosquash() {
  git rebase --interactive --autosquash "HEAD~${1:-3}"
}

function git-commit-fixup() {
  commit=$(git log --oneline | fzf | awk '{print $1}')
  git commit --fixup "$commit"

  parent_commit=$(git log --pretty=%p -1 "$commit")
  git rebase --interactive --autosquash "$parent_commit"
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
  echo "${ref#refs/heads/}"
}

function github-pr-find() {
  pr_number=$(gh pr list --limit 100 | fzf | awk '{ print $1 }')
  echo $pr_number
}

function github-pr-assigned() {
  gh pr list -S 'user-review-requested:@me'
  gh pr list -S 'reviewed-by:@me'
}

function github-pr-checkout() {
  gh pr checkout $(github-pr-find)
}

function github-pr-open() {
  pr_number=$(github-pr-find)
  gh pr view $pr_number --web >/dev/null
}

