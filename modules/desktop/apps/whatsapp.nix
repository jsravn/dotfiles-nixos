{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.whatsapp = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.whatsapp.enable {
    my.packages = with pkgs; [
      (makeDesktopItem {
        name = "whatsapp";
        desktopName = "Whatsapp";
        exec = "chromium --app=https://web.whatsapp.com";
        categories = "Productivity";
      })
    ];
  };
}
