{ pkgs, config, lib, ... }:
with lib; {
  config = {
    boot.tmpOnTmpfs = true;
    networking.networkmanager.enable = true;
    networking.firewall.logRefusedConnections = false;
  };
}
