{ lib, config, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my.home.programs.ssh = {
      enable = true;
      matchBlocks."*" = {
        compression = true;
        user = "${config.my.username}";
      };
      matchBlocks."hamster.lan" = { user = "root"; };
    };
  };
}
