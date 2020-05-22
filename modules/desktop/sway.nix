{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.sway.enable {
    my = {
      packages = with pkgs; [
        # sway
        sway
        swaybg
        swayidle
        swaylock
        xwayland

        # waybar
        waybar
        libappindicator   # tray icons
        python3           # used by waybar weather script and mediaplayer script

        # support applications
        grim
        slurp
        imagemagick
        rofi
        mako
        redshift-wlr
        gnome3.gnome-settings-daemon # for gsd-xsettings
        polkit_gnome                 # authentication popups
      ];

      home.xdg.configFile."sway".source = <config/sway>;
      home.xdg.configFile."waybar".source = <config/waybar>;

      alias.startsway = "$XDG_CONFIG_HOME/sway/startsway.sh";
    };

    # Set terminal
    my.home.xdg.configFile."sway.d/00-term.conf".text = ''
      # Set terminal
      set $term ${config.modules.desktop.term.default}
    '';

    # Add some additional useful services.
    my.home.xdg.configFile."sway.d/00-gnome.conf".text = ''
      # xsettingsd for legacy GTK apps to read GTK config via XSETTINGS protocol
      exec ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings

      # polkit authentication agent - e.g. if an app requests root access.
      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '';

    # Enable dconf for the various gnome and gtk services.
    programs.dconf.enable = true;

    # Let swaylock use PAM for authentication.
    security.pam.services.swaylock = {};
  };
}
