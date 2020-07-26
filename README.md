# dotfiles

My dotfiles. It is primarily a NixOS configuration for setting up an entire machine from scratch. In addition it also manages
an OS X system with Nix installed.

# NixOS

## Installing

From the NixOS install image use parted or similar to create the destination partition and filesystem. Then mount the root
to `/mnt` and the ESP partition to `/mnt/boot` (for UEFI systems).

``` sh
sudo -i
nix-env -iA nixos.git nixos.gnumake
git clone https://github.com/jsravn/dotfiles.git /mnt/etc/dotfiles
cd /mnt/etc/dotfiles
HOST=myhost make install
```

After rebooting, use `make move-dotfiles` to move the config into `$HOME/.dotfiles`.

### Post-install

A few manual steps are required to finish setting up a fresh system:

``` sh
# load secure dotfiles
chezmoi apply
# add ssh key to gpg-agent
ssh-add
# import pgp key
keybase-gui
keybase pgp export -s | gpg --allow-secret-key-import --import
# setup emacs
git clone git@github.com:jsravn/emacs-config ~/.config/doom
git clone https://github.com/hlissner/doom-emacs ~/.config/emacs; doom up
# setup vim
git clone https://github.com/hlissner/.vim ~/.vim; cd ~/.vim; make install
```

# OS X

Follow the [Nix manual](https://nixos.org/nix/manual/#sect-macos-installation) to install Nix as a single user install on OS X. Then
install [nix-darwin](https://github.com/LnL7/nix-darwin). Create `~/.nixpkgs/darwin-configuration.nix`:

``` nix
import "../.dotfiles" loki
```

Then clone this repo:

``` sh
git clone https://github.com/jsravn/dotfiles.git .dotfiles
```

And install it:

``` sh
cd ~/.dotfiles
make darwin-switch
```

Unfortunately most GUI packages are not well handled on Nix, so the best option is to use homebrew to install those. This repo
will manage all the dotfiles and shell configuration, and also enable `shell.nix` with lorri/direnv. It also installs a few graphical
applications that can be installed from Nix (like kitty).

# Credit

While I built this NixOS configuration for my own needs, many things were borrowed/inspired from
https://github.com/hlissner/dotfiles/ as a starting point.

