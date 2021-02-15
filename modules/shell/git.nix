{ config, lib, pkgs, ... }:
with lib; {
  options = {
    modules.shell.git = {
      managePackage = mkOption {
        type = types.bool;
        default = true;
      };
    };

  };
  config = mkIf config.modules.shell.enable {
    my = {
      packages = optionals config.modules.shell.git.managePackage (with pkgs; [
        gitAndTools.gitFull
        gitAndTools.hub
        gitAndTools.diff-so-fancy
        gitAndTools.git-filter-repo
      ]);
      home.xdg.configFile."git".source = <config/git>;
    };
  };
}
