[
  (self: super:
    with super; {
      # Custom packages.
      my = {
        cached-nix-shell = (callPackage (builtins.fetchTarball
          "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz")
          { });
        notify-send-sh = (callPackage ./notify-send-sh.nix { });
        prl-tools = (callPackage ./prl-tools.nix { kernel = config.boot.kernelPackages.kernel; });
        scmpuff = (callPackage ./scmpuff.nix { });
        xdg-desktop-portal = (callPackage ./xdg-desktop-portal.nix { });
      };

      # Make nur packages available.
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit super;
        };

      # Make unstable packages available.
      unstable = import <nixos-unstable> { inherit config; };
    })

  # Provides emacsUnstable.
  (import (builtins.fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
]
