{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.shell.zellij;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.zellij = {
    enable = mkEnableOption "Zellij";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      zellij
    ];
    home.config.file = {
      "zellij" = { source = "${configDir}/zellij"; recursive = true; };
    };
  };
}
