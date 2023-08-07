{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.shell.nu;
  configDir = config.dotfiles.configDir;
in {

  options.modules.shell.nu = { enable = mkEnableOption "Nushell"; };

  config = mkIf cfg.enable {
    environment.shells = [ pkgs.nushell ];
    user = {
      packages = with pkgs; [ nushell starship ];
      shell = pkgs.nushell;
    };

    home.config.file = {
      "nushell" = {
        source = "${configDir}/nu";
        recursive = true;
      };
    };
  };

}
