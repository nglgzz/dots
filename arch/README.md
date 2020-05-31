# [Dots](../README.md) – Arch Installation Scripts

Boot Arch linux live and run the following command to start the installation.

**DO NOT** run the command below without taking a look at the scripts first,
**it will delete all data in your device**.

<details>

<summary>Show command</summary>

```bash
sh -c "$(curl -L https://git.io/nglgzz_arch)"
```

</details>

**Requirements**

- internet connection
- boot the live USB in UEFI mode
- do not mount any device on /mnt

**Files in this folder**

- **helper.sh**: Downloads the other files and runs `install.sh`.
- **install.sh**: Partitions & formats disk, installs the base system, and calls `chroot.sh`.
- **variables.sh**: Used for setting variables and getting user input.
- **chroot.sh**: Installs bootloader, creates user, installs default packages,
  and links dots to the user.
- **pacman.list**: List of pacman packages to include in the installation.
- **aur.list**: List of AUR packages to include in the installation.

During the installation you will be asked for which device you want to install
Arch on, hostname, username, root and username passwords. Once the script has
finished, you can reboot and you're good to go.
