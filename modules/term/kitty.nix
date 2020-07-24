{ config, lib, pkgs, ... }:
with lib; {
  options.modules.term.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.term.kitty.enable {
    my = {
      packages = with pkgs; [ kitty ];

      # Kitty config.
      home.xdg.configFile."kitty" = {
        source = <config/kitty>;
      };
    };
  };
}
