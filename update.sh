ignore=`checkupdates | grep -E "haskell|pandoc|xmonad|xmobar|taffybar" | cut -d" " -f 1`
packages=`echo -n $ignore | sed 's/\s\+/,/g'`
yay -Syyu --ignore=$packages
