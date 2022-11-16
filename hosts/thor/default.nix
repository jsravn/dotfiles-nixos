# Thor is my desktop machine.

{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # General configuration
  time.timeZone = "Europe/London";

  # Modules
  modules = {
    desktop = {
      enable = true;
      gnome.enable = true;
      #kde.enable = true;
      browsers.default = "chromium";
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
      mjolnir.enable = true;
      gdrive.enable = true;
      mullvad.enable = false;
      printers.enable = true;
      roon-bridge.enable = false;
      ssh.enable = true;
    };

    work.sky.enable = true;
  };
}
