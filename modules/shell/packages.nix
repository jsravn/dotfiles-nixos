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
        iperf

        # nix utilities
        nix-prefetch-scripts
      ];
    };

    environment.systemPackages = with pkgs; [
      # Give us all the manpages.
      manpages

      # Wireguard
      wireguard-tools
    ];

    # Needed for kernel 5.4.
    boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  };
}
