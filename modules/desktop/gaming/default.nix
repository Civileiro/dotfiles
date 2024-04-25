{ config, lib, ... }:
with lib;
let cfg = config.modules.desktop.gaming;
in {

  options.modules.desktop.gaming = { };

  config = {
    # enable gamemode if we have any other gaming thing
    programs.gamemode.enable = my.anySubmoduleEnabled cfg;
  };

}
