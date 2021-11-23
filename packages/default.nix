[
  (self: super:
    with super; {
      # Custom packages.
      my = {
        cached-nix-shell = (callPackage (builtins.fetchTarball
          "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz")
          { });
        dsp = (callPackage ./dsp.nix { });
        notify-send-sh = (callPackage ./notify-send-sh.nix { });
        prl-tools = (callPackage ./prl-tools.nix { kernel = pkgs.linux; });
        roon-bridge = (callPackage ./roon-bridge.nix { });
        scmpuff = (callPackage ./scmpuff.nix { });
        sddm-themes = (callPackage ./sddm-themes.nix { });
        stepmania = (callPackage ./stepmania.nix { });
        gnome-extension-switcher = (callPackage ./switcher.nix { });
        gnome-extension-paperwm = (callPackage ./paperwm.nix { });
      };

      gnomeExtensions = super.gnomeExtensions // {
        paperwm = super.gnomeExtensions.paperwm.overrideDerivation (old: {
          version = "pre-40.0";
          src = builtins.fetchGit {
            url = https://github.com/paperwm/paperwm.git;
            ref = "next-release";
          };
        });
      };

      # Make nur packages available.
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit super;
        };

      # Make unstable packages available.
      unstable = import <nixos-unstable> {};
    })

  # Provides emacsUnstable. Pin to last known good version.
  (import (builtins.fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/8320c615b706f0d459544d7d37a59c5a5ff5e7e0.tar.gz"))
]
