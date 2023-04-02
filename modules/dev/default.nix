{ config, lib, ... }:

with lib;
let cfg = config.modules.dev;
in {
  options.modules.dev = {
    xdg.enable = mkEnableOption "XDG";
  };

  config = mkIf cfg.xdg.enable {
    # TODO
  };
}