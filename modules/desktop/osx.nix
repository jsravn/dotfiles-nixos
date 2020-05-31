# OS X Desktop Configuration.
# Reference at https://lnl7.github.io/nix-darwin/manual/index.html.
{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.osx = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.osx.enable {
    system.defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 270;
        KeyRepeat = 35;
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      dock.autohide = true;
      finder = {
        ApplwShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
      };
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
    };
  };
}
