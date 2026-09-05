declare -A npm=(
  [n]='corepack npm'
  [ni]='corepack npm install'
  [ns]='corepack npm start'
  [nt]='corepack npm test'
  [nr]='corepack npm run'
  [nb]='corepack npm run build'
  [ncirculars]="npx dpdm --warning false --circular -T --exclude 'node_modules/.*' src"
)

# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
