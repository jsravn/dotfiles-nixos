# Thor is my desktop machine.

{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # General configuration
  time.timeZone = "Europe/London";
  # Autostart JACK on sway.
  my.home.xdg.configFile."sway.d/00-jack.conf".text = ''
    exec start-jack USB20
  '';

  # Modules
  modules = {
    desktop = {
      apps.enable = true;

      browsers.default = "chromium";
      browsers.chromium.enable = true;
      #browsers.chromium.useVaapi = true;  # requires libva. In 20.03 causes a full rebuild.
      #browsers.chromium.useOzone = true;  # Wayland native version. In 20.03.causes a full rebuild.
      browsers.firefox.enable = true;

      fonts.enable = true;
      sound.enable = true;

      sway.enable = true;
      sway.hwmonTemp = "/sys/class/hwmon/hwmon0/temp1_input";

      term.default = "kitty";
      term.kitty.enable = true;

      themes.gnome.enable = true;

      xdg-mime.enable = true;
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

    security = {
      # make-linux-fast-again.com
      mitigations.disable = true;
      mitigations.acceptRisk = true;
    };

    services = {
      docker.enable = true;
      mullvad.enable = true;
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

    system = {
      inspect.enable = true;
      network-manager.enable = true;
      tmp-tmpfs.enable = true;
    };

    users.james.enable = true;

    work = {
      sky.enable = true;
    };
  };
}
