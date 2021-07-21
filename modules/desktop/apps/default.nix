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
        #discord
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
        #unstable.plexamp
        # Override the unstable desktop which doesn't work on Nixos 20.09.
        (makeDesktopItem {
          name = "plexamp";
          desktopName = "Plexamp";
          icon = "${pkgs.unstable.plexamp}/share/icons/hicolor/512x512/apps/plexamp.png";
          categories = "AudioVideo";
          exec = "${pkgs.unstable.plexamp}/bin/plexamp %U";
        })
        unstable.plex-media-player
        peek
        samba
        slack
        spotify
        tdesktop # telegram
        thunderbird
        vulkan-tools
        wireshark
        unstable.zoom-us

        # Games
        lutris
        steam
        minecraft

        # Windows only
        wineWowPackages.stable
        winetricks
      ];

      home.xdg.configFile."kitty".source = <config/kitty>;
      home.xdg.configFile."mpv".source = <config/mpv>;

      home.xdg.systemDirs.data = [
        "/var/lib/flatpak/exports/share"
        "/home/${config.my.username}/.local/share/flatpak/exports/share"
      ];
    };

    services.flatpak.enable = true;
  };
}
