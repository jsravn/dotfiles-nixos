{ config, lib, pkgs, ... }:
with lib; {
  imports =
    [ ./gnome.nix ./keybase.nix ./media.nix ./obs-studio.nix ./sonarworks.nix ./syncthing.nix ];

  config = mkIf config.modules.desktop.enable {
    my = {
      packages = with pkgs; [
        audacity
        calibre
        discord
        dr14_tmeter
        dropbox
        gimp-with-plugins
        gitter
        glxinfo
        libreoffice
        gparted
        mpv
        pinta
        plexamp
        plex-media-player
        samba
        slack
        spotify
        tdesktop # telegram
        thunderbird
        vulkan-tools
        wireshark
        zoom-us

        # Games
        lutris
        steam

        # Windows only
        wineWowPackages.stable

        # Browser apps
        (makeDesktopItem {
          name = "fastmail";
          desktopName = "Fastmail";
          icon = "emblem-mail";
          exec = "chromium --app=https://fastmail.com";
          categories = "X-Productivity";
        })
        (makeDesktopItem {
          name = "outlook";
          desktopName = "Outlook";
          icon = "emblem-mail";
          exec = "chromium --app=https://outlook.office.com";
          categories = "X-Productivity";
        })
        (makeDesktopItem {
          name = "whatsapp";
          desktopName = "Whatsapp";
          exec = "chromium --app=https://web.whatsapp.com";
          categories = "X-Productivity";
        })
      ];

      home.xdg.configFile."mpv".source = <config/mpv>;
    };
  };
}
