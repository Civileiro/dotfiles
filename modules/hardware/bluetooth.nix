{ config, lib, ... }:
with lib;
let cfg = config.modules.hardware.bluetooth;
in {

  options.modules.hardware.bluetooth = { enable = mkEnableOption "Bluetooth"; };

  config = mkIf cfg.enable { hardware.bluetooth.enable = true; };
}
