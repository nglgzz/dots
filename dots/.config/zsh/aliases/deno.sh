declare -A deno=(
  [n]='deno'
  [ni]='deno install'
  [nr]='deno task'
  [ns]='deno task start'
  [nd]='deno task dev'
  [nb]='deno task build'
  [nt]='deno test'
)

function pj() {
  if [[ -f "deno.jsonc" ]]; then
    jq ."$1" deno.jsonc
  elif [[ -f "deno.json" ]]; then
    jq ."$1" deno.json
  elif [[ -f "package.json" ]]; then
    jq ."$1" package.json
  fi
}
