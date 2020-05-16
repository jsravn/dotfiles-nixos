{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.shell.isync = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.isync.enable {
    my = {
      packages = with pkgs; [
        isync
      ];

      home.home.file.".mbsyncrc".source = <config/isync/mbsyncrc>;
    };
  };
}
