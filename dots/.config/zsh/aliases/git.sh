declare -A git=(
  [g]='git'
  [gs]='git status'
  [ga]='git add'
  [gaa]='git add -A'
  [gd]='git diff'
  [gdd]='git diff --staged'
  [gddd]='git diff HEAD^1 HEAD'

  [gf]='git fetch'
  [gp]='git pull'
  [gu]='git fetch origin && git rebase origin'
  [gg]='git push origin $(git_current_branch)'
  [ggwp]='git push --force-with-lease origin $(git_current_branch)'

  [gno]='git restore --staged'
  [gco]='git checkout'
  [gb]='git branch'

  [gl]='git ls'
  [gls]='git log --show-signature'
  [gfind]='git log --oneline | fzf | awk '\''{print $1}'\'''
  [gsn]='git show --name-only'
  [gsh]='git show $(gfind)'
  [gshq]='git show --name-only $(gfind)'

  [gctmp]='git commit -m tmp --no-verify'
  [gca]='git commit --amend'
  [gcaa]='git commit --amend --no-edit'
  [gcf]='git-commit-fixup'
  [gcff]='git-commit-fixup-autosquash'

  [ghpr]="github-pr-open"
  [gha]="github-pr-assigned"
  [ghco]="github-pr-checkout"
)

function git-commit-fixup-autosquash() {
  git rebase --interactive --autosquash "HEAD~${1:-3}"
}

function git-commit-fixup() {
  git history fixup "$(gfind)"
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

