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
        xe

        # system utils
        sysstat
        dstat
        htop
        btop
        rclone

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

        # build utils
        bazelisk

        # dev utilities
        binutils-unwrapped-all-targets
        patchelf
      ];
    };

    environment.systemPackages = with pkgs; [
      # Give us all the manpages.
      man-pages

      # Wireguard
      wireguard-tools
    ];
  };
}
