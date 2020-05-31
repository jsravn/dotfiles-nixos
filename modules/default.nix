# Entry point to all of the modules.
#
# Each module is guarded by a config flag and is enabled by the host configuration.

{ ... }:
{
  imports = [
    <home-manager/nixos>
    ./core        # core module is always loaded and includes the basics
    ./desktop     # X11/Wayland desktop apps
    ./dev         # Development tools
    ./editors     # General purpose editors for editing stuff
    ./shell       # Shell apps
    ./security    # Security settings
    ./services    # Background services
    ./system      # System tools
    ./users       # Manage users
    ./work        # Work specific settings to enable on work computers
  ];
}
