{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  options.modules.desktop.browsers = {
    default = mkOption {
      type = types.str;
      default = "firefox";
    };

    defaultDesktop = mkOption {
      type = types.str;
      default = "firefox.desktop";
    };
  };

  config = mkIf cfg.enable {
    my.packages = with pkgs; [
      google-chrome
      firefox-bin
    ];

    my.env.BROWSER = cfg.browsers.default;
  };
}
