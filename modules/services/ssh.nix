{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.ssh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.ssh.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
    };
    programs.mosh.enable = true;
  };
}
