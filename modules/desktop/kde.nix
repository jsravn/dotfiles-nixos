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
      autorun = true;
    };

    security.pam.services.kdm.enableKwallet = true;

    environment.systemPackages = with pkgs; [
      kde-gtk-config
    ];
  };
}
