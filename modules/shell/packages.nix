{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        # net utils
        ldns
        lsof
        sipcalc
        bind
      ];
    };

    # Give us all the manpages.
    environment.systemPackages = [ pkgs.manpages ];
  };
}
