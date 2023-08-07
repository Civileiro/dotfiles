# modules/services/networkmanager.nix

{ config, lib, ... }:
with lib;
let cfg = config.modules.services.networkmanager;
in {
  options.modules.services.networkmanager = {
    enable = mkEnableOption "Network Manager";
  };

  config = mkIf cfg.enable {
    # Enable networking
    networking.networkmanager.enable = true;

    user.extraGroups = [ "networkmanager" ];
  };
}
