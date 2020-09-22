{ pkgs ? import <nixpkgs-unstable> {} }:
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
  ] ++ (if pkgs.stdenv.isLinux then [ keepassx2 ] else []);
}
