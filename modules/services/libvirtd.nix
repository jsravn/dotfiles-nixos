# libvirtd VM management
# ensure that kvm-intel is added as a kernel module
{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.libvirtd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.libvirtd.enable {
    environment.systemPackages = with pkgs; [ virtmanager ];
    my = {
      user.extraGroups = [ "libvirtd" ];
    };

    virtualisation.libvirtd = {
      enable = true;
    };
  };
}
