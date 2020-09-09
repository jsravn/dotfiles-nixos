{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.sway;
  swayPackage = pkgs.sway.override {
    extraOptions = [ "--verbose" "--unsupported-gpu" ];
    extraSessionCommands = ''
      # Fix Java apps.
      export _JAVA_AWT_WM_NONREPARENTING=1
      # For xdpw (screen sharing).
      # Disable these for now - as they break a lot of apps (like zoom).
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      # For Firefox.
      export MOZ_ENABLE_WAYLAND=1
    '';
    withBaseWrapper = true;
    withGtkWrapper = true;
  };
in {
  options.modules.desktop.sway = {
    temperatureHwmonPath = mkOption {
      type = types.str;
      default = "";
    };
    temperatureHwmonName = mkOption {
      type = types.str;
      default = "";
    };
    extraConfig = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };

  config = mkIf config.modules.desktop.enable {
    environment.systemPackages = with pkgs; [
      # sway is a system package so it can be found by graphical session managers.
      swayPackage

      # Add NetworkManager applet.
      # For some reason, nm-applet can't find icons as a user package so install it as a system package.
      gnome3.networkmanagerapplet
      hicolor-icon-theme
    ];

    security.pam.services.swaylock = { };
    # To make a Sway session available if a display manager like SDDM is enabled:
    services.xserver.displayManager.sessionPackages = [ swayPackage ];
    fonts.enableDefaultFonts = true;
    programs.dconf.enable = true;

    my = {
      packages = with pkgs; [
        # sway extra packages
        swaybg
        swayidle
        swaylock
        xwayland

        # waybar
        unstable.waybar # unstable contains a sleep/resume fix, and temp fix
        libappindicator # tray icons

        # support applications
        grim
        slurp
        mako # notifications
        wl-clipboard
        imagemagick
        rofi
        libnotify
        my.notify-send-sh
        playerctl # music control
        pamixer
        gnome3.gnome-settings-daemon # for gsd-xsettings
        polkit_gnome # authentication popups
      ];

      # Provide a convenient alias to log outputs.
      alias.start-sway = "sway >~/.cache/sway-out.txt 2>~/.cache/sway-err.txt";

      # Sway config.
      home.xdg.configFile."sway".source = <config/sway>;

      # Waybar config.
      home.xdg.configFile."waybar" = {
        source = <config/waybar>;
        recursive = true;
      };
      home.xdg.configFile."waybar/config".text =
        replaceStrings [ "HWMON_PATH_ABS" "HWMON_INPUT_FILENAME" ] [ cfg.temperatureHwmonPath cfg.temperatureHwmonName ]
        (readFile <config/waybar/config.tmpl>);

      # Machine specific config.
      home.xdg.configFile."sway.d/00-extra.conf".text = ''
        ${concatStringsSep "\n" config.modules.desktop.sway.extraConfig}
      '';

      # Set terminal.
      home.xdg.configFile."sway.d/00-term.conf".text = ''
        # Set terminal
        set $term ${config.modules.term.default}
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
