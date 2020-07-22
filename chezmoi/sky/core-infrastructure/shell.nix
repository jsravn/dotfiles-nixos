let
  pkgs = import <nixpkgs> {};
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
  ];
}
