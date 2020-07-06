{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.obs-studio;
  package = pkgs.symlinkJoin {
    name = "obs";
    paths = [ pkgs.obs-studio ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obs \
        --set QT_QPA_PLATFORM xcb
    '';
  };

  mkPluginEnv = packages:
    let
      pluginDirs = map (pkg: "${pkg}/share/obs/obs-plugins") packages;
      plugins = concatMapStringsSep " " (p: "${p}/*") pluginDirs;
    in pkgs.runCommand "obs-studio-plugins" {
      preferLocalBuild = true;
      allowSubstitutes = false;
    } ''
      mkdir $out
      [[ '${plugins}' ]] || exit 0
      for plugin in ${plugins}; do
        ln -s "$plugin" $out/
      done
    '';
in {
  options = {
    programs.obs-studio = {
      enable = mkEnableOption "obs-studio";

      plugins = mkOption {
        default = [ ];
        example = literalExample "[ pkgs.obs-linuxbrowser ]";
        description = "Optional OBS plugins.";
        type = types.listOf types.package;
      };
    };
  };

  config = mkIf config.modules.desktop.enable {
    programs.obs-studio.plugins = with pkgs; [
      obs-wlrobs             # capture wayland desktop
    ];
    my = {
      packages = [ package ];
      home.xdg.configFile."obs-studio/plugins" =
        mkIf (cfg.plugins != [ ]) { source = mkPluginEnv cfg.plugins; };
    };
  };
}
