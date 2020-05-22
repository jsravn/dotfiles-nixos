# Thor is my desktop machine.

{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # General configuration
  time.timeZone = "Europe/London";

  # Modules
  modules = {
    desktop = {
      apps.discord.enable = true;
      apps.dropbox.enable = true;
      #apps.evolution.enable = true;
      apps.gnome-utils.enable = true;
      apps.keybase.enable = true;
      apps.slack.enable = true;
      apps.sonarworks.enable = true;
      apps.spotify.enable = true;
      browsers.default = "chromium";
      browsers.chromium.enable = true;
      fonts.enable = true;
      sound.enable = true;
      sway.enable = true;
      term.default = "kitty";
      term.kitty.enable = true;
      xdg-mime.enable = true;
    };

    dev = {
      go.enable = true;
    };

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

    services = {
      docker.enable = true;
    };

    shell = {
      chezmoi.enable = true;
      direnv.enable = true;
      git.enable = true;
      gpg.enable = true;
      isync.enable = true;
      mu.enable = true;
      scmpuff.enable = true;
      zsh.enable = true;
    };

    work = {
      sky.enable = true;
    };
  };
}