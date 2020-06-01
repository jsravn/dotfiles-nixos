{ config, lib, pkgs, ... }:
with lib;
{
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        gitAndTools.hub
        gitAndTools.diff-so-fancy
      ];
      # Do recursively, in case git stores files in this folder
      home.xdg.configFile = {
        "git/config".source = <config/git/config>;
        "git/ignore".source = <config/git/ignore>;
      };
    };
  };
}
