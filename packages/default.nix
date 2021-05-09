[
  (self: super:
    with super; {
      # Custom packages.
      my = {
        cached-nix-shell = (callPackage (builtins.fetchTarball
          "https://github.com/xzfc/cached-nix-shell/archive/master.tar.gz")
          { });
        notify-send-sh = (callPackage ./notify-send-sh.nix { });
        prl-tools = (callPackage ./prl-tools.nix { kernel = pkgs.linux; });
        roon-bridge = (callPackage ./roon-bridge.nix { });
        scmpuff = (callPackage ./scmpuff.nix { });
        sddm-themes = (callPackage ./sddm-themes.nix { });
        stepmania = (callPackage ./stepmania.nix { });
        gnome-extension-switcher = (callPackage ./switcher.nix { });
        gnome-extension-paperwm = (callPackage ./paperwm.nix { });
      };
    })
]
