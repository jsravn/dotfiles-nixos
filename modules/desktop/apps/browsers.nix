{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  options.modules.desktop.browsers = {
    default = mkOption {
      type = types.str;
      default = "google-chrome-stable";
    };

    defaultDesktop = mkOption {
      type = types.str;
      default = "google-chrome.desktop";
    };
  };

  config = mkIf cfg.enable {
    my.packages = with pkgs; [
      (google-chrome.override {
        commandLineArgs = [
          "--password-store=basic"
        ];
      })
      firefox-bin
      (unstable.tor-browser-bundle-bin.overrideAttrs (old: rec {
        version = "11.0.2";
        src = fetchurl {
          url = "https://dist.torproject.org/torbrowser/11.0.2/tor-browser-linux64-11.0.2_en-US.tar.xz";
          sha256 = "1bqlb8dlh92dpl9gmfh3yclq5ii09vv333yisa0i5gpwwzajnh5s";
        };
      }))
    ];

    my.env.BROWSER = cfg.browsers.default;
  };
}
