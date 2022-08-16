# KDE
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
      displayManager.sddm.enable = true;
      autorun = true;
    };

    security.pam.services.sddm.enableKwallet = true;

    environment.systemPackages = with pkgs; [
      kde-gtk-config
    ];
  };
}
