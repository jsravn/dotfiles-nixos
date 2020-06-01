{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.browsers.chromium;
in {
  options.modules.desktop.browsers = {
    default = mkOption {
      type = types.str;
      default = "chromium";
    };
  };

   options.modules.desktop.browsers.chromium = {
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

  config = mkIf config.modules.desktop.enable {
    my.packages = with pkgs; [
      (chromium.override {
        enableWideVine = true;
        useOzone = cfg.useOzone;
        useVaapi = cfg.useVaapi;
      })
      firefox-bin
    ];
  };
}
