{ pkgs, config, lib, ... }:
with lib;
{
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        isync
        unstable.mu
      ];

      home.home.file.".mbsyncrc".source = <config/isync/mbsyncrc>;
    };
  };
}
