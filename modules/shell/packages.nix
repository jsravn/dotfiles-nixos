{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        my.cached-nix-shell

        # net utils
        ldns
        lsof
        sipcalc
        bind

        # system utils
        pciutils
        libsysfs
        lm_sensors
        gdb
      ];
    };

    # Give us all the manpages.
    environment.systemPackages = [ pkgs.manpages ];
  };
}
