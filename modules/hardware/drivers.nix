{ config, lib, ... }:
with lib;
let cfg = config.modules.hardware.drivers;
in {

  options.modules.hardware.drivers = {
    enable = mkEnableOption "Extra Kernel Drivers";
    rtl8821au.enable = mkEnableOption "rtl8821au";
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages;
      [ (mkIf cfg.rtl8821au.enable rtl8821au) ];
    boot.initrd.kernelModules = [ (mkIf cfg.rtl8821au.enable "8821au") ];
  };
}
