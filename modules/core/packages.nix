{ pkgs, ... }: {
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
  ];
}
