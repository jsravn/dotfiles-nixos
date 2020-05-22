{ pkgs, ... }:
{
  # Core system packages.
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
    libsysfs
    my.cached-nix-shell # for instant nix-shell scripts
  ];
}
