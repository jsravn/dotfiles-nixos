# Manage graphical login with SDDM.
{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    environment.systemPackages = with pkgs; [ my.sddm-themes.sddm-sugar-dark ];
    services.xserver.enable = true;
    services.xserver.displayManager = {
      sddm.enable = true;
      sddm.theme = "sugar-dark";
      defaultSession = "sway";
    };
  };
}
