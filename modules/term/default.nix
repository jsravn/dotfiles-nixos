{ config, lib, pkgs, ... }:
with lib; {
  options = {
    modules.term = {
      default = mkOption {
        type = types.str;
        default = "kitty";
      };
    };
  };

  imports = [ ./kitty.nix ./tmux.nix ];
}
