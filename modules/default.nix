## Common modules
{ lib, pkgs, ... }: {
  imports = [
    ./core # core module is always loaded and includes the basics
    ./dev # Development tools
    ./editors # General purpose editors for editing stuff
    ./shell # Shell apps
    ./term # Terminals
    ./work # Work specific settings to enable on work computers
  ];
}
