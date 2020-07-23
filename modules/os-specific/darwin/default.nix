# Darwin specific configuration, using nix-darwin.

{ lib, stdenv, ... }:
with lib; {
  imports = [ <home-manager/nix-darwin> ];

  config = mkIf stdenv.isDarwin {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # Default shell.
    programs.zsh.enable = true;

    # Dotfiles location.
    my.dotfiles = "/Users/${config.my.username}/.dotfiles";
  };
}
