{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.sway;
in {
  options.modules.desktop.sway = {
    hwmonTemp = mkOption {
      type = types.str;
      default = "/sys/class/hwmon/hwmon0/temp1_input";
    };
  };

  config = mkIf config.modules.desktop.enable {
    programs.sway = {
      enable = true;
      extraOptions = [ "--verbose" "--unsupported-gpu" ];
      extraSessionCommands = ''
        # Fix Java apps.
        export _JAVA_AWT_WM_NONREPARENTING=1
        # For xdpw (screen sharing).
        # Disable these for now - as they break a lot of apps (like zoom).
        #export XDG_SESSION_TYPE=wayland
        #export XDG_CURRENT_DESKTOP=sway
        # For Firefox.
        export MOZ_ENABLE_WAYLAND=1
      '';
      wrapperFeatures.gtk = true;
    };

    # For some reason, nm-applet can't find icons as a user package.
    environment.systemPackages = with pkgs; [
      gnome3.networkmanagerapplet
      hicolor-icon-theme
    ];

    my = {
      packages = with pkgs; [
        # sway extra packages
        swaybg
        swayidle
        swaylock
        xwayland

        # waybar
        waybar
        libappindicator # tray icons

        # support applications
        grim
        slurp
        wl-clipboard
        imagemagick
        rofi
        mako                         # notifications
        libnotify
        my.notify-send-sh
        playerctl                    # music control
        pamixer
        gnome3.gnome-settings-daemon # for gsd-xsettings
        polkit_gnome                 # authentication popups
        python3                      # switcher
      ];

      alias.start-sway = "sway >~/.cache/sway-out.txt 2>~/.cache/sway-err.txt";

      home.xdg.configFile."sway".source = <config/sway>;

      home.xdg.configFile."waybar" = {
        source = <config/waybar>;
        recursive = true;
      };
      home.xdg.configFile."waybar/config".text = ''
        {
          "layer": "top",
          "modules-left": ["sway/workspaces", "sway/mode"],
          "modules-center": ["sway/window"],
          "modules-right": [
            "custom/spotify",
            "custom/weather",
            "memory",
            "cpu",
            "temperature",
            "idle_inhibitor",
            "clock",
            "tray"
          ],
          "clock": {
            "format": "{:%a %b %e, %H:%M}"
          },
          "memory": {
            "format": "{percentage}% "
          },
          "cpu": {
            "format": "{usage}% "
          },
          "temperature": {
            "hwmon-path": "${cfg.hwmonTemp}",
            "critical-threshold": 40,
            "format-critical": "{temperatureC}°C ",
            "format": "{temperatureC}°C "
          },
          "idle_inhibitor": {
            "format": "{icon}",
            "format-icons": {
              "activated": "",
              "deactivated": ""
            }
          },
          "tray": {
            "icon-size": 18
          },
          "custom/weather": {
            "format": "{}",
            "format-alt": "{alt}: {}",
            "format-alt-click": "click-right",
            "interval": 600,
            "return-type": "json",
            "exec": "~/.config/waybar/weather.sh Richmond,UK",
            "exec-if": "ping wttr.in -c1"
          },
          "custom/spotify": {
            "format": "{} ",
            "return-type": "json",
            "max-length": 60,
            "exec": "~/.config/waybar/mediaplayer.py 2> /dev/null",
            "exec-if": "pgrep spotify"
          }
        }
      '';

      # Set terminal
      home.xdg.configFile."sway.d/00-term.conf".text = ''
        # Set terminal
        set $term ${config.modules.desktop.term.default}
      '';

      # Start some gnome services.
      home.xdg.configFile."sway.d/00-gnome.conf".text = ''
        # gnome-keyring-daemon provides the secrets API for storing secrets
        # relies on the wrapper created by services.gnome3.gnome-keyring.enable = true
        exec /run/wrappers/bin/gnome-keyring-daemon --start --components=secrets,pkcs11

        # xsettingsd for legacy GTK apps to read GTK config via XSETTINGS protocol
        exec ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings

        # polkit authentication agent - e.g. if an app requests root access.
        exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '';

      # Set up mako.
      home.xdg.configFile."mako/config".text = ''
        icons=1
        icon-path=${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita
      '';
    };
  };
}
