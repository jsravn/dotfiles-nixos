# Darwin specific configuration, using nix-darwin.

{ ... }: {
  imports = [ <home-manager/nix-darwin> ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Default shell.
  programs.zsh.enable = true;
}
