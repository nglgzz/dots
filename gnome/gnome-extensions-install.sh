#!/bin/bash -eu

array=(https://extensions.gnome.org/extension/6099/paperwm/  https://extensions.gnome.org/extension/615/appindicator-support/)

for url in "${array[@]}"; do
    extension_id=$(curl -s "$url" | grep -oP 'data-uuid="\K[^"]+')
    extension_shell_version_map=$(curl -s "$url" | grep -oP 'data-svm="\K[^"]+' | sed 's/&quot;/"/g')
    version_tag=$(echo "$extension_shell_version_map" | jq 'map(.pk) | max')

    # Alternative approach, but it doesn't seem to always work.
    # version_tag=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$extension_id" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')

    # Skip installing if the extension is already installed.
    if gnome-extensions list | grep --quiet "${extension_id}"; then
        echo "${extension_id} already installed, skipping."
        continue
    fi

    # Skip downloading if the extension is already dowloaded.
    if [[ ! -f "${extension_id}.zip" ]]; then
        echo "downloading extension: $extension_id, version: $version_tag"
        wget -qO "${extension_id}.zip" "https://extensions.gnome.org/download-extension/${extension_id}.shell-extension.zip?version_tag=$version_tag"
    fi

    echo "installing extension: $extension_id, version: $version_tag"
    busctl --user call org.gnome.Shell.Extensions \
        /org/gnome/Shell/Extensions \
        org.gnome.Shell.Extensions \
        InstallRemoteExtension s "${extension_id}" || true

    # The install request through busctl returns early, so after it we need to
    # poll to check if the extension was installed.
    max_tries=10
    while [[ "$max_tries" != 0 ]]; do
        if gnome-extensions list | grep --quiet "${extension_id}"; then
            gnome-extensions enable "${extension_id}"
            rm "${extension_id}.zip"
            break
        fi

        max_tries=$((max_tries - 1))
        sleep 1
    done

    if [[ "$max_tries" == 0 ]]; then
        echo "Failed to install ${extension_id}"
        exit 1
    fi
done
