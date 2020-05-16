{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.shell.keybase = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.keybase.enable {
    my = {
      packages = with pkgs; [
        keybase
      ];
    };
  };
}
