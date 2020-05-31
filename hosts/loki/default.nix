# Loki is a macbook (experimental).
# See https://lnl7.github.io/nix-darwin/manual/index.html#sec-options for nix-darwin options.

{ pkgs, ... }:
{
  # General configuration
  time.timeZone = "Europe/London";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Modules
  modules = {
    desktop = {
      apps.discord.enable = true;
      apps.dropbox.enable = true;
      apps.fastmail.enable = true;
      apps.gitter.enable = true;
      apps.keybase.enable = true;
      apps.outlook.enable = true;
      apps.slack.enable = true;
      apps.spotify.enable = true;
      apps.whatsapp.enable = true;

      browsers.default = "chromium";
      browsers.chromium.enable = true;
      browsers.firefox.enable = true;

      term.default = "kitty";
      term.kitty.enable = true;

      osx.enable = true;
    };

    dev = {
      cc.enable = true;
      go.enable = true;
    };

    editors = {
      default = "vim";
      emacs.enable = true;
      vim.enable = true;
    };

    shell = {
      cached-nix-shell.enable = true;
      chezmoi.enable = true;
      direnv.enable = true;
      git.enable = true;
      gpg.enable = true;
      isync.enable = true;
      kubernetes.enable = true;
      manpages.enable = true;
      mu.enable = true;
      netutils.enable = true;
      scmpuff.enable = true;
      zsh.enable = true;
    };

    users.james-darwin.enable = true;

    work = {
      sky.enable = true;
    };
  };
}
