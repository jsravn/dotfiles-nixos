{ lib, config, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my.home.programs.ssh = {
      enable = true;
      compression = true;
      matchBlocks."*" = {
        user = "${config.my.username}";
      };
      matchBlocks."hamster.lan" = { user = "root"; };
    };
  };
}
