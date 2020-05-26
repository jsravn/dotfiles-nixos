{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.outlook = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.outlook.enable {
    my.packages = with pkgs; [
      (makeDesktopItem {
        name = "outlook";
        desktopName = "Outlook";
        icon = "emblem-mail";
        exec = "chromium --app=https://outlook.office.com";
        categories = "Productivity";
      })
    ];
  };
}
