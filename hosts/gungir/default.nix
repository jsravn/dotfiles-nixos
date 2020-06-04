# Gungir is my VM based installation of NixOS.
#
# It is intended mostly for testing, but also installing on Windows/MacOS systems.

{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  # General configuration
  time.timeZone = "Europe/London";

  # Modules
  modules = {
    desktop = {
      apps.dropbox.enable = true;
      #apps.evolution.enable = true;
      apps.gnome-utils.enable = true;
      apps.keybase.enable = true;
      apps.sonarworks.enable = true;
      apps.spotify.enable = true;

      browsers.default = "chromium";
      browsers.chromium.enable = true;

      sway.enable = true;

      term.default = "kitty";
      term.kitty.enable = true;
    };

    dev = { go.enable = true; };

    editors = {
      default = "vim";
      emacs.enable = true;
      vim.enable = true;
    };

    security = {
      # make-linux-fast-again.com
      mitigations.disable = true;
      mitigations.acceptRisk = true;
    };

    services = { docker.enable = true; };

    shell = {
      chezmoi.enable = true;
      direnv.enable = true;
      git.enable = true;
      gpg.enable = true;
      isync.enable = true;
      keybase.enable = true;
      mu.enable = true;
      scmpuff.enable = true;
      zsh.enable = true;
    };

    work = { sky.enable = true; };
  };
}
