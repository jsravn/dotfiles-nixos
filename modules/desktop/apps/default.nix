{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./gnome-utils.nix
    ./keybase.nix
    ./sonarworks.nix
  ];

  options.modules.desktop.apps = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.enable {
    my = {
      packages = with pkgs; [
        discord
        dropbox
        gitter
        libreoffice
        lutris
        samba
        slack
        spotify
        steam
        redshift-wlr
        zoom-us

        # Browser apps.
        (makeDesktopItem {
          name = "fastmail";
          desktopName = "Fastmail";
          icon = "emblem-mail";
          exec = "chromium --app=https://fastmail.com";
          categories = "Productivity";
        })
        (makeDesktopItem {
            name = "outlook";
            desktopName = "Outlook";
            icon = "emblem-mail";
            exec = "chromium --app=https://outlook.office.com";
            categories = "Productivity";
        })
        (makeDesktopItem {
            name = "whatsapp";
            desktopName = "Whatsapp";
            exec = "chromium --app=https://web.whatsapp.com";
            categories = "Productivity";
        })
      ];

      # Start up dropbox automatically in Sway.
      home.xdg.configFile."sway.d/50-dropbox.conf".text = mkIf config.modules.desktop.sway.enable ''
        exec dropbox
      '';

      # Redshift config.
      home.xdg.configFile."redshift.conf".text = ''
        [redshift]
        location-provider=manual
        temp-day=6500

        [manual]
        lat=${config.my.latitude}
        lon=${config.my.longitude}
      '';
    };

    # For lutris and steam.
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    hardware.pulseaudio.support32Bit = true;
  };
}
