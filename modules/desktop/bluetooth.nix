{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.bluetooth = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf config.modules.desktop.bluetooth.enable {
    services.blueman.enable = true;
    modules.desktop.sway.extraConfig = ["exec blueman-applet"];
  };
}
