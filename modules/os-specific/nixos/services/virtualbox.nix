{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.virtualbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.virtualbox.enable {
    virtualisation.virtualbox = {
      host.enable = true;
      host.package = pkgs.virtualbox.overrideAttrs (oldAttrs: rec {
          qtWrapperArgs = [
            # virtualbox breaks if XDG_SESSION_TYPE is set to wayland
            "--unset XDG_SESSION_TYPE"
          ];
      });
    };
    users.extraGroups.vboxusers.members = [ config.my.username ];
  };
}
