let
  pkgs = import <nixpkgs-unstable> {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    gnumake
    ansible
    go
    adoptopenjdk-bin
    buildkit
    kustomize
    gradle
    jq
    keepassx2
  ];
}
