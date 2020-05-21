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

    # Start up automatically in Sway.
    my.home.xdg.configFile."sway.d/50-dropbox.conf".text = ''
      exec dropbox
    '';
  };
}
