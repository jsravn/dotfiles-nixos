NIXOS_VERSION	:= 20.03
USER            := james
HOME			:= /home/$(USER)
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
	echo "import ../nixfiles \"$(HOST)\"" > $(NIXOS_PREFIX)/configuration.nix

move-nixfiles: $(HOME)/.nixfiles
$(HOME)/.nixfiles:
	mkdir -p $(HOME)
	sudo mv /etc/nixfiles $(HOME)/.nixfiles
	sudo ln -s $(HOME)/.nixfiles /etc/nixfiles
	chown -R $(USER):users $(HOME) $(HOME)/.nixfiles

format:
	nixfmt $(shell find . -name '*.nix')
