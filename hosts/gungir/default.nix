# Gungir is my VM based installation of NixOS.
#
# It is intended mostly for testing, but also installing on Windows/MacOS systems.

{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  # General configuration
  time.timeZone = "Europe/London";
  # Needed to support VMWare in Sway.
  my.env.WLR_NO_HARDWARE_CURSORS = 1;

  # Modules
  modules = {
    desktop = {
      enable = true;
      browsers.default = "chromium";
      sway.extraConfig = [
        "output Virtual-1 mode 2560x1600"
      ];
    };

    dev = {
      # cc.enable = true;
      go.enable = true;
      node.enable = true;
    };

    editors = {
      default = "vim";
      emacs.enable = true;
      intellij.enable = true;
      vim.enable = true;
    };

    # make-linux-fast-again.com
    security.mitigations.disable = true;
    security.mitigations.acceptRisk = true;

    services = {
      docker.enable = true;
      libvirtd.enable = true;
      mullvad.enable = true;
      printers.enable = true;
    };

    shell.enable = true;

    work.sky.enable = true;
  };
}
