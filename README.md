# Config Files/Scripts
Some of my configuration files that I use to sync across my machines.

GNU Stow used to handle the symlinks.

### Brew
Run brew bundle to execute Brewfile.

### Vim
Some vim configuration requires plugins, handled by Vundle. Install script in .vim/bin/install.

To make install executable if not already, chmod +x the file within command line.

### Known Errors
Might get some errors while Vundle is installing, but can be ignored.
Possibly due to asynchronous behavior; config lines which rely on plugins are being invoked before they are installed.

