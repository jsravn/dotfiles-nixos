{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.fastmail = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.fastmail.enable {
    my.packages = with pkgs; [
      (makeDesktopItem {
        name = "fastmail";
        desktopName = "Fastmail";
        icon = "emblem-mail";
        exec = "chromium --app=https://fastmail.com";
        categories = "Productivity";
      })
    ];
  };
}
