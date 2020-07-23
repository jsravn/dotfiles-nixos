# Darwin specific configuration, using nix-darwin.

{ config, ... }: {
  imports = [ <home-manager/nix-darwin> ];

  config = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # Enable the zsh interactive module.
    programs.zsh = {
      enable = true;
      promptInit = "";
      # Our zsh config sets up completion.
      enableCompletion = false;
    };

    # Dotfiles location.
    my.dotfiles = "/Users/${config.my.username}/.dotfiles";
  };
}
