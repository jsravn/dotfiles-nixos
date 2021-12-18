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
      };

      gnomeExtensions = super.gnomeExtensions // {
        paperwm = super.gnomeExtensions.paperwm.overrideDerivation (old: {
          version = "pre-41.0";
          src = super.fetchFromGitHub {
            owner = "paperwm";
            repo = "PaperWM";
            rev = "e9f714846b9eac8bdd5b33c3d33f1a9d2fbdecd4";
            sha256 = "0wdigmlw4nlm9i4vr24kvhpdbgc6381j6y9nrwgy82mygkcx55l1";
          };
          patches = old.patches
            ++ [ ./paperwm.patch ./paperwm2.patch ];
        });
      };

      # Make unstable packages available.
      unstable = import <nixos-unstable> { };
    })

  # Provides emacsUnstable. Pin to last known good version.
  (import (builtins.fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
]
