{ options, ... }:
{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";

  # Optimise hard disk space of store.
  nix.autoOptimiseStore = true;

  # Add search paths so they can be referenced directly in modules.
  nix.nixPath = options.nix.nixPath.default ++ [
    "bin=/etc/nixfiles/bin"
    "config=/etc/nixfiles/config"
  ];

  # Add custom overlays to override packages.
  # See https://nixos.org/nixpkgs/manual/#chap-overlays for details.
  nixpkgs.overlays = import ../../packages;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Aliases for nixos.
  environment.shellAliases = {
    nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
    nix-shell = ''NIX_PATH="nixpkgs-overlays=/etc/nixfiles/packages/default.nix:$NIX_PATH" nix-shell'';
  };
}
