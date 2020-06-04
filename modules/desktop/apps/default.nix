{ config, lib, pkgs, ... }:
with lib; {
  imports = [ ./apps.nix ./gnome-utils.nix ./keybase.nix ./sonarworks.nix ];
}
