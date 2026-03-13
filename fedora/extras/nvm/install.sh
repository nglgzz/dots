#!/bin/bash -ex

latest_version=$(gh release view \
	--repo nvm-sh/nvm \
	--json 'tagName' --jq '.tagName')

export XDG_CONFIG_HOME="$HOME/.config"
export PROFILE=/dev/null

curl -f "https://raw.githubusercontent.com/nvm-sh/nvm/$latest_version/install.sh" | bash
