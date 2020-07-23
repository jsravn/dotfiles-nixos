# Darwin specific configuration, using nix-darwin.

{ config, ... }:
{
  imports = [ <home-manager/nix-darwin> ];

  config = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # Dotfiles location.
    my.dotfiles = "/Users/${config.my.username}/.dotfiles";
  };
}
