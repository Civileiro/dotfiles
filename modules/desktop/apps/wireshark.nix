{ config, lib, ... }:
with lib;
let 
  cfg = config.modules.desktop.apps.wireshark;
in {
  options.modules.desktop.apps.wireshark = {
    enable = mkEnableOption "Wireshark";
  };

  config = mkIf cfg.enable {
    user.extraGroups = [ "wireshark" ];
    programs.wireshark.enable = true;
  };
}