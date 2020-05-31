{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.shell.cached-nix-shell = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.cached-nix-shell.enable {
    my = {
      packages = with pkgs; [
        my.cached-nix-shell
      ];
    };
  };
}
