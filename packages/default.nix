[
  (self: super: with super; {
    # Custom packages.
    my = {
      firmwareLinuxNonfree = (callPackage ./firmware-linux-nonfree.nix {});
      scmpuff = (callPackage ./scmpuff.nix {});
      notify-send-sh = (callPackage ./notify-send-sh.nix {});
      cached-nix-shell =
        (callPackage
          (builtins.fetchTarball
            https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz) {});
    };

    # Make nur packages available.
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit super;
    };

    # Make unstable packages available.
    unstable = import <nixos-unstable> { inherit config; };
  })

  # emacs git
  (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
]
