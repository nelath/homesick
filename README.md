homesick
=========

This repo is a clone of https://github.com/andsens/homeshick that has been simplified to
support only zsh and bash and has been renamed to homesick again and extended to support
bootstrapping scripts as part of the first install.

By the power of git, homesick enables you to synchronize dotfiles across computers.

However bare bones these machines are, provided that at least Bash 3 and Git 1.5 are available you can use homesick.
homesick can handle multiple dotfile repositories. This means that you can install
larger frameworks like [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
or a multitude of emacs or vim plugins alongside your own customizations without clutter.

Quick install
-------------

homesick is installed to your own home directory and does not require root privileges to be installed.
```sh
git clone https://github.com/michaelrommel/homesick.git $HOME/.homesick/repos/homesick
```

To invoke homesick, source the `homesick.sh` script from your rc-script:
```sh
# from sh and its derivates (bash, dash, ksh, zsh etc.)
printf '\nsource "$HOME/.homesick/repos/homesick/homesick.sh"' >> $HOME/.bashrc
```
