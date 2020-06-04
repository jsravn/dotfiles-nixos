{ config, lib, pkgs, ... }:
with lib; {
  options.modules.shell.manpages = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.manpages.enable {
    environment.systemPackages = [ pkgs.manpages ];
    documentation.dev.enable = true;
  };
}
