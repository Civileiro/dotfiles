{ config, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.gaming.steam;
in {

  options.modules.desktop.gaming.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true; 
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true; 
    };
  };

}
