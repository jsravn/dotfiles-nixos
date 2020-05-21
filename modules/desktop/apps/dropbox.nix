{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.dropbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.dropbox.enable {
    my.packages = with pkgs; [
      dropbox
    ];
  };
}
