#!/bin/bash -eu

array=(paperwm@paperwm.github.com appindicatorsupport@rgcjonas.gmail.com)

for extension_id in "${array[@]}"; do
    # Skip installing if the extension is already installed
    if gnome-extensions list | grep --quiet "${extension_id}"; then
        echo "${extension_id} already installed, skipping."
        continue
    fi

    busctl --user call org.gnome.Shell.Extensions \
        /org/gnome/Shell/Extensions \
        org.gnome.Shell.Extensions \
        InstallRemoteExtension s "${extension_id}"

    rm "${extension_id}".zip
done
