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
        #unstable.plexamp
        # Override the unstable desktop which doesn't work on latest Nixos.
        # (makeDesktopItem {
        #   name = "plexamp";
        #   desktopName = "Plexamp";
        #   icon =
        #     "${pkgs.unstable.plexamp}/share/icons/hicolor/512x512/apps/plexamp.png";
        #   categories = "AudioVideo";
        #   exec = "${pkgs.unstable.plexamp}/bin/plexamp %U";
        # })
        #plex-media-player
        (unstable.plex-mpv-shim.overrideAttrs (oldAttrs: rec {
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ (with unstable.python3Packages; [ tkinter pystray ]);
        }))
        peek
        samba
        slack
        spotify
        #tdesktop # telegram
        #thunderbird
        vulkan-tools
        wireshark
        zoom-us
        #mattermost-desktop

        # Dev tools
        unstable.ghidra-bin
        pwndbg
        teensy-loader-cli

        # Games
        lutris
        minecraft

        # Windows only
        wineWowPackages.stable
        winetricks

        # Extra
        (appimage-run.override { extraPkgs = pkgs: [ pkgs.gmp ]; })
      ];

      home.xdg.configFile."kitty".source = <config/kitty>;
      home.xdg.configFile."mpv".source = <config/mpv>;

      home.xdg.systemDirs.data = [
        "/var/lib/flatpak/exports/share"
        "/home/${config.my.username}/.local/share/flatpak/exports/share"
      ];
    };

    programs.steam.enable = true;
    environment.systemPackages = with pkgs;
      [
        # provides steam-run command
        steam-run-native
      ];

    # flatpak apps
    services.flatpak.enable = true;

    # netdata for system monitoring
    services.netdata.enable = true;

    # gc adapter, teensy
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789a]*", ENV{MTP_NO_PROBE}="1"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", MODE:="0666", RUN:="${pkgs.coreutils}/bin/stty -F /dev/%k raw -echo"
      KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", MODE:="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="013*", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="013*", MODE:="0666"
    '';

    # qmk udev rules
    services.udev.packages = [ pkgs.unstable.qmk-udev-rules ];
  };
}
