{ config, lib, pkgs, ... }:
with lib; {
  imports = [ ./apps.nix ./gnome-utils.nix ./keybase.nix ./obs-studio.nix ./sonarworks.nix ];
}
