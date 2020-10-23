{ config, lib, pkgs, ... }:
with lib; {
  imports =
    [ ./keybase.nix ./obs-studio.nix ./sonarworks.nix ];

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

        # Gnome utility apps
        gnome3.eog # Image viewer
        gnome3.evince # PDF/Document Viewer
        gnome3.gedit # A generic text editor
        gnome3.gnome-calculator # A nice calculator
        gnome3.gnome-disk-utility # Format disks from nautilus
        gnome3.nautilus # File browser
        gnome3.seahorse # Secret browser
      ];

      # Start up dropbox automatically in Sway
      home.xdg.configFile."sway.d/50-dropbox.conf".text = ''
        exec dropbox
      '';
    };

    # Add support for mounting network filesystems to Nautilus
    services.gvfs.enable = true;

    # Unlock gnome-keyring on login. Requires a keyring called "login".
    services.gnome3.gnome-keyring.enable = true;
  };
}
