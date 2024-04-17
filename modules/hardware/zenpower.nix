{ config, lib, ... }:
with lib;
let cfg = config.modules.hardware.zenpower;
in {
  options.modules.hardware.zenpower = {
    enable = mkEnableOption "Zenpower module";
  };

  config = mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [ "k10temp" ];
      extraModulePackages = [ config.boot.kernelPackages.zenpower ];
    };
  };
}
