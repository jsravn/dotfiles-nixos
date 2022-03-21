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
          pname = "gnome-shell-extension-paperwm-community";
          version = "3dc1e34c88df44184120abf4a6e689d1cfa73cc5";
          src = super.fetchFromGitHub {
            owner = "PaperWM-community";
            repo = "PaperWM";
            rev = version;
            sha256 = "039vfgmxzw8flmd70arbnr21l0s4avbra7h184ikvp6spw89jg6a";
          };
          patches = [ ./paperwm-prefs.patch ];
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
