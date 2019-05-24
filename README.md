# Config Files/Scripts
Some of my configuration files that I use to sync across my machines.

GNU Stow used to handle the symlinks.

Within dotfiles, use stow command to create symlink. Stow will not rewrite the file if it already exists prior to being stowed. stow -D to unstow.

### Gitignore
Useful for ignoring DS_Stores and tags from ctags. Basic gitignore taken from Github Help.

To allow a global gitignore:
```
git config --global core.excludesfile ~/.gitignore_global
```

### Brew
Run brew bundle to execute Brewfile.

### Vim
Some vim configuration requires plugins, handled by Vundle. Install script in .vim/bin/install.

To make install executable if not already, chmod +x the file within command line.

Example:

If untouched / default file paths, the command:
```
chmod +x ~/.vim/bin/install
```
should make it executable.

Then:
```
~/.vim/bin/install
```
should run the script to install vim plugins.

If access denied, you may need administrator privilege / sudo.

### TODO:

- Create install script for everything.
  - git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
- Less dependent on Homebrew? Linux-focused?
