#!/bin/bash -eu

nvm_dir="${NVM_DIR:-~/.nvm}"
nvm unload
rm -rf "$nvm_dir"
