{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [ gitAndTools.hub gitAndTools.diff-so-fancy ]
      ++ optional pkgs.stdenv.isLinux [ gitAndTools.gitFull ];
    };
  };
}
