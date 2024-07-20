{ config, lib, ... }:
with lib;
let cfg = config.modules.desktop.gaming;
in {

  options.modules.desktop.gaming = { };

  config = lib.mkIf (my.anySubmoduleEnabled cfg) {
    # enable gamemode if we have any other gaming thing
    programs.gamemode.enable = true;
    user.extraGroups = [ "gamemode" ];
  };

}
