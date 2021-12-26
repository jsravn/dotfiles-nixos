{ config, options, pkgs, lib, ... }:
with lib; {
  imports = [ ./kmonad/nix/nixos-module.nix ];

  options.modules.services.kmonad = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.kmonad.enable {
    services.kmonad = {
      enable = true;
      configfiles = [ "/home/james/.config/kmonad/miryoku_kmonad.kbd" ];
    };
    my = {
      home.xdg.configFile."kmonad".source = <config/kmonad>;
      user.extraGroups = [ "input" "uinput" ];
    };
  };
}
