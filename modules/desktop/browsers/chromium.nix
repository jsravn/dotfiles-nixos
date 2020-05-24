{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.browsers.chromium;
in {
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

  config = mkIf cfg.enable {
    my.packages = with pkgs; [
      (chromium.override {
        useOzone = cfg.useOzone;
        useVaapi = cfg.useVaapi;
      })
    ];
  };
}
