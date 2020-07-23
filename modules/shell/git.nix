{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [ gitAndTools.gitFull gitAndTools.hub gitAndTools.diff-so-fancy ];
    };
  };
}
