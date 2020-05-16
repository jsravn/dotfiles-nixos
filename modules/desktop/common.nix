{ config, lib, pkgs, ... }:
{
  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.daemon.config = {
    # 5 is good - see https://gitlab.freedesktop.org/pulseaudio/pulseaudio/issues/310
    resample-method = "speex-float-5";
    flat-volumes = "no";
    # fix pa bug with realtime scheduling
    rlimit-rttime = "-1";
    default-sample-format = "float32le";
    default-sample-rate = "48000";
    alternate-sample-rate = "44100";
  };
  my.packages = with pkgs; [
    pavucontrol
  ];

  # Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      noto-fonts-emoji
      font-awesome-ttf
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
        monospace = [ "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
      # Ensure missing emojis/unicode characters fallback to Noto.
      localConf = ''
        <fontconfig>
          <match target="pattern">
              <edit name="family" mode="append">
                  <string>Noto Color Emoji</string>
              </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  # Redshift config
  my.home.xdg.configFile."redshift.conf".text = ''
    [redshift]
    location-provider=manual
    temp-day=6500

    [manual]
    lat=${config.my.latitude}
    lon=${config.my.longitude}
  '';

  # GTK-3 theme.
  my.home.xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-icon-theme-name=Adwaita
    gtk-theme-name=Adwaita-dark
    gtk-font-name=DejaVu Sans 11
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=0
    gtk-toolbar-style=GTK_TOOLBAR_BOTH
    gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
    gtk-button-images=1
    gtk-menu-images=1
    gtk-enable-event-sounds=1
    gtk-enable-input-feedback-sounds=1
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintfull
    gtk-xft-rgba=rgb
  '';
}
