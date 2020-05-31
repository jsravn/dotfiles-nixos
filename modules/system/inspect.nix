{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.system.inspect = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.system.inspect.enable {
    my = {
      packages = with pkgs; [
        pciutils
        libsysfs
        lm_sensors
      ];
    };
  };
}
