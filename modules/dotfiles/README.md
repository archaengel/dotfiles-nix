# Archaengel's Config Repository

Currently managed with GNU Stow. To install the config for a given application,
clone this repository in the `$HOME` directory, so that the cloned directory is a
child of the `$HOME` directory. From the top level of the cloned repo, run:

```sh
stow <pkg-config>
```

For example, to install the config for neovim in the `$HOME directory`, from
`$HOME/dotfiles`, one would run:

```sh
stow nvim
```
