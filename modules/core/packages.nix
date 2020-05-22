{ pkgs, ... }:
{
  # Core packages for all systems.
  environment.systemPackages = with pkgs; [
    coreutils
    git
    killall
    unzip
    vim
    wget
    curl
    gnumake
    file
    pciutils
    my.cached-nix-shell # for instant nix-shell scripts
  ];
}
