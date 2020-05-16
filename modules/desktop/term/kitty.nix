{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.term.kitty;
in {
  options.modules.desktop.term.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    my = {
     packages = with pkgs; [
       kitty
     ];

     home.xdg.configFile."kitty".source = <config/kitty>;
    };
  };
}
