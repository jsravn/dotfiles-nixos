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
        paperwm = gnomeExtensions.paperwm.overrideAttrs (old: rec {
          pname = "gnome-shell-extension-paperwm-ccope";
          version = "132bbb5c1aa0a7923e02afebee1aa7e3e3569221";
          src = super.fetchFromGitHub {
            owner = "ccope";
            repo = "PaperWM";
            rev = version;
            sha256 = "sha256-0w5o3isDvXSmJ9N56qOIxnHz3XGKvBRgmGVB9LbiWEM=";
          };
        });
      };

      # Make unstable packages available.
      unstable = import <nixos-unstable> {
        config.allowUnfree = true;
      };
    })

  # Provides emacsUnstable. Pin to last known good version.
  (import (builtins.fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
]
