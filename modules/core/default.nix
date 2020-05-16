# The core system configuration.
#
# This is applied to all systems and contains the core configuration for NixOS and the base.
#

{ ... }:
{
  imports = [
    ./home.nix
    ./networking.nix
    ./nixos.nix
    ./packages.nix
    ./system.nix
  ];
}
