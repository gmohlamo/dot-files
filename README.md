# Some user installations to make first

* JetBrains Mono Font
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
```
* NVM
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

* Oh-My-Bash
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

* YAY
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

# Packages to get

This should be the baseline without getting any images etc...
```bash
sudo pacman -S xmonad xmonad-contrib xmonad-dbus taffybar kitty git feh xcompmgr github-cli neovim python-pynvim powerline
```

To be fair, this is really a work in progress...

