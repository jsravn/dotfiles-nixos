# Loki is my laptop.

{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # General configuration
  time.timeZone = "America/Denver";

  # Font sizes
  home.xdg.configFile."kitty/custom.conf".text =  ''
    font_size 16.0
  '';

  # Modules
  modules = {
    desktop = {
      enable = true;
      gnome.enable = true;
      browsers.default = "chromium";
      bluetooth.enable = true;
    };

    dev = {
      cc.enable = true;
      go.enable = true;
      java.enable = true;
      node.enable = true;
      python3.enable = true;
    };

    editors = {
      default = "nvim";
      intellij.enable = true;
      vim.enable = true;
      emacs.enable = true;
    };

    services = {
      docker.enable = true;
      libvirtd.enable = true;
      lorri.enable = false;
      mjolnir.enable = false;
      mullvad.enable = false;
      printers.enable = true;
      roon-bridge.enable = false;
      ssh.enable = false;
    };

    work.sky.enable = true;
  };
}
