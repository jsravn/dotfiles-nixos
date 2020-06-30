{ pkgs, config, lib, ... }:
with lib; {
  config = {
    boot.tmpOnTmpfs = true;
    # many modern apps require a large number of watches.
    boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;
    networking.networkmanager.enable = true;
    networking.firewall.logRefusedConnections = false;
  };
}
