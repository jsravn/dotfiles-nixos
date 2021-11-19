let
  pkgs = import <nixos> {};
  unstable = import <nixpkgs-unstable> {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      # to execute 32-bit binaries easily with steam-run
      steam-run-native
      pwndbg
      pwntools
      tcpdump
      zlib
      mpack
      hivex
      jdk8
      dos2unix
      hexedit
      xinetd

      (pkgs.python3.withPackages (p: with p; [
        pynacl
        pwntools
        joblib
      ]))
      libseccomp
    ];
  }
