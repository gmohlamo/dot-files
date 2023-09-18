# How to prevent Arch from breaking new package versions

Use the following commands to update the system without updating haskell and our WM requirements.
If this is being done on a virtual machine, it might be a good idea to set a snapshot of the system before you update.
This should ensure that the system does not break...
```bash
ignore=`checkupdates | grep -E "haskell|xmonad|xmobar|taffybar" | cut -d" " -f 1`
packages=`echo -n $ignore | sed 's/\s\+/,/g'`
yay -Syyu --ignore=$packages
```

## TODO
Explore means to access working package versions should we perform a new installation of the system.
[Arch Linux Archives](https://wiki.archlinux.org/title/Arch_Linux_Archive) might be a good place to start looking.
