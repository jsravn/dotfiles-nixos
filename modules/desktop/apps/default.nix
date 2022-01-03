{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./browsers.nix
    ./gnome-apps.nix
    ./keybase.nix
    ./media.nix
    ./sonarworks.nix
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
        plex-mpv-shim
        peek
        samba
        slack
        spotify
        vulkan-tools
        wireshark
        zoom-us

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

      home.xdg.configFile."kitty/kitty.conf".source = <config/kitty/kitty.conf>;
      home.xdg.configFile."kitty/custom.conf".text = lib.mkDefault ''
        # Custom config for kitty. Override in host specific configuration.
      '';
      home.xdg.configFile."mpv".source = <config/mpv>;
      home.xdg.configFile."plex-mpv-shim" = {
        source = <config/plex-mpv-shim>;
        recursive = true;
        force = true;
      };

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
