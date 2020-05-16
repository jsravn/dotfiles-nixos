{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.browsers.chromium = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.browsers.chromium.enable {
    my.packages = with pkgs; [
      chromium
    ];
  };
}
