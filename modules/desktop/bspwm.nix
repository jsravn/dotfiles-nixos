{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.bspwm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.bspwm.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
    ];

    # for redshift
    location = {
      latitude = config.my.latitude;
      longitude = config.my.longitude;
    };

    services = {
      picom = {
        enable = true;
        fade = true;
        fadeDelta = 1;
        fadeSteps = [ "0.01" "0.012" ];
        shadow = true;
        shadowOffsets = [ (-10) (-10) ];
        shadowOpacity = "0.22";
        # activeOpacity = "1.00";
        # inactiveOpacity = "0.92";
        settings = {
          shadow-radius = 12;
          # blur-background = true;
          # blur-background-frame = true;
          # blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 320;
        };
      };
      redshift.enable = true;
      xserver = {
        enable = true;
        displayManager.defaultSession = "none+bspwm";
        displayManager.lightdm.enable = true;
        displayManager.lightdm.greeters.mini = {
          enable = true;
          user = "james";
        };
        displayManager.sessionCommands = ''
          xrdb -merge "$XDG_CONFIG_HOME"/xtheme/*
        '';
        windowManager.bspwm.enable = true;
      };
    };

    my = {
      home.xdg.configFile = {
        "bspwm".source = <config/bspwm>;
        "dunst".source = <config/dunst>;
        "polybar".source = <config/polybar>;
        "rofi".source = <config/rofi>;
        "sxhkd".source = <config/sxhkd>;
        "xtheme".source = <config/xtheme>;
      };

      packages = with pkgs; [
        feh # background images

        (writeScriptBin "rofi" ''
          #!${stdenv.shell}
          exec ${rofi}/bin/rofi -terminal kitty -m -1 "$@"
        '')
        # Fake rofi dmenu entries
        (makeDesktopItem {
          name = "rofi-bookmarkmenu";
          desktopName = "Open Bookmark in Browser";
          icon = "bookmark-new-symbolic";
          exec = "${<bin/rofi/bookmarkmenu>}";
        })
        (makeDesktopItem {
          name = "rofi-filemenu";
          desktopName = "Open Directory in Terminal";
          icon = "folder";
          exec = "${<bin/rofi/filemenu>}";
        })
        (makeDesktopItem {
          name = "rofi-filemenu-scratch";
          desktopName = "Open Directory in Scratch Terminal";
          icon = "folder";
          exec = "${<bin/rofi/filemenu>} -x";
        })

        (makeDesktopItem {
          name = "lock-display";
          desktopName = "Lock screen";
          icon = "system-lock-screen";
          exec = "${<bin/zzz>}";
        })
      ];
    };
  };
}
