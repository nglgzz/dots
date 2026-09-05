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
  jq ."$1" deno.jsonc
}
