# Utilities for dealing with media, such as for transcodes.
{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    my.packages = with pkgs; [
      mediainfo
      ffmpeg
      flac
      lame
      sox
      mkvtoolnix
      mktorrent
    ];
  };
}
