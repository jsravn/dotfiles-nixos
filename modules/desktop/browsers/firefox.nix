{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.browsers.firefox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.browsers.firefox.enable {
    my.packages = with pkgs; [
      firefox-bin
    ];
  };
}
