# [Dots](../README.md) – Ubuntu Installation Scripts

**Requirements**

- Fresh Ubuntu live image, don't use an old one as half of the time there's
  issues with outdated packages / sources.

- If there is some unusual partition setup currently installed the installer
  might fail, in such case use gparted from the live distro to manually clear
  the target device before installing.

Boot the live image, select "Try and install", follow
the steps, and when prompted for a URL for an automatic install, specify one of
the following urls:

```
https://ubuntu.nglgzz.com/home.yml
https://ubuntu.nglgzz.com/work.yml
```

During the installation you will be asked for which device you want to install
Ubuntu on, hostname, username, root and username passwords.

**Post install**

After the installer is complete, reboot the device, log in, and run the
following command.

> **DO NOT** run the command without taking a look at the scripts first. It will
> make changes to your system that are not easily reversible.

<details>

<summary>Show command</summary>

```bash
sh -c "$(curl -L https://ubuntu.nglgzz.com/postinstall.sh)"
```

</details>
