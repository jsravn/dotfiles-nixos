# Manage graphical login with SDDM.
{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    environment.systemPackages = with pkgs; [
      my.sddm-themes.sddm-sugar-dark
      qt5.qtgraphicaleffects
      qt5.qtquickcontrols2
      qt5.qtsvg
    ];
    services.xserver.enable = true;
    services.xserver.displayManager = {
      sddm.enable = true;
      sddm.theme = "sugar-dark";
      defaultSession = "sway";
    };
    # Unlock gnome keyring.
    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
