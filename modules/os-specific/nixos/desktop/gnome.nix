# Gnome
# Start with: systemctl start display-manager.service
{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf config.modules.desktop.gnome.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
      autorun = false;
    };
  };
}
