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
    programs.sway.enable = true;
    programs.sway.extraOptions = [ "--verbose" "--unsupported-gpu" ];
    programs.sway.extraSessionCommands = ''
      # Fix Java apps.
      export _JAVA_AWT_WM_NONREPARENTING=1
      # for xdpw
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
    '';
    programs.sway.wrapperFeatures.gtk = true;

    my = {
      packages = with pkgs; [
        # sway extra packages
        swaybg
        swayidle
        swaylock
        xwayland

        # waybar
        waybar
        libappindicator   # tray icons

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
  };
}
