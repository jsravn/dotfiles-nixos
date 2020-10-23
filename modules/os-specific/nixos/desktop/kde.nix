# Legacy xorg environment to support things I can't do easily in Wayland - like screen sharing.
# Start with: systemctl start display-manager.service
{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.kde = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf config.modules.desktop.kde.enable {
    services.xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      autorun = false;
    };
  };
}