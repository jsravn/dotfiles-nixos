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

        # serial
        screen
        uucp

        # misc utils
        entr
        watch
        jq
        dstat

        # nix utilities
        nix-prefetch-scripts
      ];
    };

    # Give us all the manpages.
    environment.systemPackages = [ pkgs.manpages ];
  };
}
