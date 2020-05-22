{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.shell.mu = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.mu.enable {
    my = {
      packages = with pkgs; [
        unstable.mu
      ];
    };
  };
}
