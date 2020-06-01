{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.term = {
    default = mkOption {
      type = types.str;
      default = "kitty";
    };
  };

  config = mkIf config.modules.desktop.enable {
    my = {
     packages = with pkgs; [
       kitty
     ];

     home.xdg.configFile."kitty".source = <config/kitty>;
    };
  };
}
