{ config, lib, pkgs, ... }:
with lib; {
  imports =
    [ ./gnome.nix ./keybase.nix ./obs-studio.nix ./sonarworks.nix ];

  config = mkIf config.modules.desktop.enable {
    my = {
      packages = with pkgs; [
        calibre
        discord
        dropbox
        gitter
        glxinfo
        libreoffice
        mpv
        pinta
        samba
        slack
        spotify
        tdesktop # telegram
        thunderbird
        wireshark
        (zoom-us.overrideAttrs (oldAttrs: rec {
          qtWrapperArgs = oldAttrs.qtWrapperArgs ++ [
            # zoom breaks if XDG_SESSION_TYPE is set to wayland
            "--unset XDG_SESSION_TYPE"
          ];
        }))

        # Games
        unstable.lutris
        unstable.steam

        # Browser apps
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
    };
  };
}
