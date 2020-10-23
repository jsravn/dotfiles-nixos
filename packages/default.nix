[
  (self: super:
    with super; {
      # Custom packages.
      my = {
        cached-nix-shell = (callPackage (builtins.fetchTarball
          "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz")
          { });
        emacsMacport = callPackage ./emacsMacport {
          inherit (pkgs.darwin.apple_sdk.frameworks) AppKit GSS ImageIO;
          stdenv = pkgs.clangStdenv;
        };
        notify-send-sh = (callPackage ./notify-send-sh.nix { });
        prl-tools = (callPackage ./prl-tools.nix { kernel = pkgs.linux; });
        scmpuff = (callPackage ./scmpuff.nix { });
        sddm-themes = (callPackage ./sddm-themes.nix { });
        stepmania = (callPackage ./stepmania.nix { });
      };

      # Make nur packages available.
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit super;
        };

      # Make unstable packages available. On darwin, pkgs is always unstable.
      unstable = if super.pkgs.stdenv.isLinux then
        import <nixos-unstable> { inherit config; }
      else
        import <nixpkgs-unstable> { inherit config; };
    })

  # Provides emacsUnstable.
  (import (builtins.fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
]
