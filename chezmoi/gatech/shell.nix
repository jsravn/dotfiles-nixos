let
  pkgs = import <nixpkgs-unstable> {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    gnumake
    gdb
  ];
}
