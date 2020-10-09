{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  options.modules.desktop.browsers = {
    default = mkOption {
      type = types.str;
      default = "firefox";
    };

    chromium = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      useOzone = mkOption {
        type = types.bool;
        default = false;
      };

      useVaapi = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    my.packages = with pkgs; [
      (chromium.override {
        enableWideVine = true;
        useOzone = cfg.browsers.chromium.useOzone;
        enableVaapi = cfg.browsers.chromium.useVaapi;
      })
      firefox-bin
    ];

    my.env.BROWSER = cfg.browsers.default;
  };
}
