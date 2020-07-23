NIXOS_VERSION	:= 20.03
USER            := james
PREFIX          := /mnt
NIXOS_PREFIX	:= $(PREFIX)/etc/nixos
FLAGS			:= -I "config=$$(pwd)/config" \
				   -I "modules=$$(pwd)/modules" \
				   -I "bin=$$(pwd)/bin" \
				   $(FLAGS)

all: add-channels build

test:
	sudo nixos-rebuild $(FLAGS) test

check-host:
	@[ -f hosts/$(HOST)/default.nix ] || (echo "error: hosts/$(HOST) does not exist - did you export HOST?" && exit 1)

install: check-host add-channels update install-config
	nixos-install --root "$(PREFIX)" $(FLAGS)
# Fix for home-manager which relies on nix-env having created the profile store first.
# But in our case, we use home-manager as a system module, so this folder won't exist.
	mkdir -p "$(PREFIX)/nix/var/nix/profiles/per-user/$(USER)"

update: add-channels
	sudo nix-channel --update

up: upgrade
upgrade: update switch

s: switch
switch: add-channels
	sudo nixos-rebuild $(FLAGS) switch

build: add-channels
	sudo nixos-rebuild $(FLAGS) build

boot: add-channels
	sudo nixos-rebuild $(FLAGS) boot

gc:
	sudo nix-collect-garbage -d

rollback:
	sudo nixos-rebuild $(FLAGS) --rollback $(COMMAND)

add-channels:
	sudo nix-channel --add "https://nixos.org/channels/nixos-${NIXOS_VERSION}" nixos
	sudo nix-channel --add "https://github.com/rycee/home-manager/archive/release-${NIXOS_VERSION}.tar.gz" home-manager
	sudo nix-channel --add "https://nixos.org/channels/nixos-unstable" nixos-unstable

install-config: $(NIXOS_PREFIX)/configuration.nix
$(NIXOS_PREFIX)/configuration.nix:
	echo "import ../dotfiles \"$(HOST)\"" > $(NIXOS_PREFIX)/configuration.nix

move-dotfiles: $(HOME)/.dotfiles
$(HOME)/.dotfiles:
	mkdir -p $(HOME)
	sudo mv /etc/dotfiles $(HOME)/.dotfiles
	sudo ln -s $(HOME)/.dotfiles /etc/dotfiles
	chown -R $(USER):users $(HOME) $(HOME)/.dotfiles

format:
	nixfmt $(shell find . -name '*.nix')

## Darwin
darwin-add-channels:
	nix-channel --add "https://github.com/LnL7/nix-darwin/archive/master.tar.gz" darwin
	nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixpkgs
	nix-channel --add "https://nixos.org/channels/nixos-unstable" nixos-unstable
	nix-channel --add "https://github.com/rycee/home-manager/archive/master.tar.gz" home-manager

darwin-update: darwin-add-channels
	nix-channel --update

darwin-switch:
	darwin-rebuild $(FLAGS) switch
