{ config, lib, ... }:
with lib;
let cfg = config.modules.hardware.tablet;
in {
  options.modules.hardware.tablet = {
    enable = mkEnableOption "Tablet Drivers";
  };
  config = mkIf cfg.enable { hardware.opentabletdriver.enable = true; };
}

