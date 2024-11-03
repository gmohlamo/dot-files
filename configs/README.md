# How to use this directory as a form of config management

## Setting up symlinks using `stow`:
```bash
stow -d . -t ~ * -v
```

## Removing those links:
```bash
stow -D -d . -t ~ * -v
```
