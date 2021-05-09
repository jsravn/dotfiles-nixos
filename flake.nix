{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url  = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.thor = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ./system.nix
        ./hardware.nix
        ./apps.nix
      ];
    };
  };
}
