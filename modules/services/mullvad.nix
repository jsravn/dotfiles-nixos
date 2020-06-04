{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.mullvad = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.mullvad.enable {
    environment.systemPackages = with pkgs; [ unstable.mullvad-vpn ];
    # Taken from unstable: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/mullvad-vpn.nix.
    boot.kernelModules = [ "tun" ];
    systemd.services.mullvad-daemon = {
      description = "Mullvad VPN daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      after = [
        "network-online.target"
        "NetworkManager.service"
        "systemd-resolved.service"
      ];
      path = [
        pkgs.iproute
        # Needed for ping
        "/run/wrappers"
      ];
      serviceConfig = {
        StartLimitBurst = 5;
        StartLimitIntervalSec = 20;
        ExecStart =
          "${pkgs.unstable.mullvad-vpn}/bin/mullvad-daemon -v --disable-stdout-timestamps";
        Restart = "always";
        RestartSec = 1;
      };
    };
  };
}
