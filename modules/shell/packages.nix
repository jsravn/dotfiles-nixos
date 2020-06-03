{ pkgs, config, lib, ... }:
with lib;
{
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        my.cached-nix-shell

        # net utils
        ldns
        lsof
        sipcalc

        # system utils
        pciutils
        libsysfs
        lm_sensors
      ];
    };

    # Give us all the manpages.
    environment.systemPackages = [ pkgs.manpages ];
    documentation.dev.enable = true;
  };
}
