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
        httpie
        curlie
        tcptrack
        iperf
        whois
        conntrack-tools
        iftop
        mtr
        ngrep

        # system utils
        sysstat
        dstat

        # serial
        screen
        uucp

        # misc utils
        entr
        watch
        jq
        graphviz
        gh
        psmisc

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
  };
}
