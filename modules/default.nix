## Common modules
{ lib, pkgs, ... }: {
  imports = [
    ./core # Core module is always loaded and includes the basics
    ./desktop # Graphical desktop
    ./dev # Development tools
    ./editors # General purpose editors for editing stuff
    ./shell # Shell configuration
    ./security # Security related modules
    ./services # Background services
    ./work # Work specific settings to enable on work computers
  ];
}
