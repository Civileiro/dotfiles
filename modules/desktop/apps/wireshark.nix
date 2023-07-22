{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.desktop.apps.wireshark;
in {
  options.modules.desktop.apps.wireshark = {
    enable = mkEnableOption "Wireshark";
  };

  config = mkIf cfg.enable {
    user.extraGroups = [ "wireshark" ];
    user.packages = [ pkgs.wireshark ];
    programs.wireshark.enable = true;
  };
}
