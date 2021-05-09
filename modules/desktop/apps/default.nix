{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./browsers.nix
    ./gnome-apps.nix
    ./keybase.nix
    ./media.nix
    ./obs-studio.nix
    ./sonarworks.nix
    ./syncthing.nix
  ];

  config = mkIf config.modules.desktop.enable {
    my = {
      packages = with pkgs; [
        # Desktop apps
        audacity
        calibre
        deluge
        discord
        dr14_tmeter
        dropbox
        gimp-with-plugins
        gitter
        glxinfo
        kitty
        libreoffice
        gparted
        mpv
        pinta
        plexamp
        plex-media-player
        peek
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
        minecraft

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

      home.xdg.configFile."kitty".source = <config/kitty>;
      home.xdg.configFile."mpv".source = <config/mpv>;
    };
  };
}
