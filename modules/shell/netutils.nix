{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.shell.netutils = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.netutils.enable {
    my = {
      packages = with pkgs; [
        ldns
        lsof
        pciutils
        libsysfs
        lm_sensors
      ];
    };
  };
}
