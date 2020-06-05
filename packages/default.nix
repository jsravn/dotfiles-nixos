[
  (self: super:
    with super; {
      # Custom packages.
      my = {
        cached-nix-shell = (callPackage (builtins.fetchTarball
          "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz")
          { });
        firmwareLinuxNonfree = (callPackage ./firmware-linux-nonfree.nix { });
        notify-send-sh = (callPackage ./notify-send-sh.nix { });
        scmpuff = (callPackage ./scmpuff.nix { });
        xdg-desktop-portal-wlr = (callPackage ./xdg-desktop-portal-wlr.nix { });
      };

      # Make nur packages available.
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit super;
        };

      # Make unstable packages available.
      unstable = import <nixos-unstable> { inherit config; };
    })

  # emacs git
  (import (builtins.fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
]
