# Loki is a macbook that relies on nix-darwin.

{ config, lib, pkgs, ... }:
with lib;
let
  mkOptionStr = value:
    mkOption {
      type = types.str;
      default = value;
    };
in {
options = {
  my = {
    username = mkOptionStr "james";
  };
};

config = {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ neovim
      exa
      zsh
      nix-zsh-completions
      fasd
      fd
      fzf
      tldr
      htop
      chezmoi
      kitty
      lastpass-cli

      tmux

      kubectl
      kubectx

      emacsMacport
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls
      imagemagick
      zstd
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      languagetool
      editorconfig-core-c
      sqlite
      clang
      ccls
      pandoc
      nixfmt
      shfmt
      shellcheck
      yaml-language-server
    ];

  launchd.user.envVariables = {
    XDG_CONFIG_HOME = "/Users/${config.my.username}/.config";
    XDG_CACHE_HOME = "/Users/${config.my.username}/.cache";
    XDG_DATA_HOME = "/Users/${config.my.username}/.local/share";
    XDG_BIN_HOME = "/Users/${config.my.username}/.local/bin";
    ZDOTDIR = "/Users/${config.my.username}/.config/zsh";
    ZSH_CACHE = "/USers/${config.my.username}/.cache/zsh";
  };

  environment.systemPath = [
    "$XDG_CONFIG_HOME/emacs/bin"
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
};
}
}
