# Darwin specific configuration, using nix-darwin.

{ config, pkgs, ... }: {
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

    # Remove zsh cache files.
    # Remove zgen files when NixOS configuration changes so it reconfigures.
    system.activationScripts.cleanupZsh = ''
      pushd /Users/${config.my.username}/.cache
      rm -rf zsh/*
      rm -f zgen/init.zsh
      popd
    '';

    # Link home-manager packages to ~/Applications.
    system.build.applications = pkgs.buildEnv {
      name = "system-applications";
      paths = config.my.packages;
      pathsToLink = "/Applications";
    };
  };
}
