{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.dwm;
in {
  options.modules.desktop.dwm = {
    enable = mkEnableOption "DWM";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
    };
  };
}
