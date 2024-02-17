{ config, lib, ... }:
with lib;
let cfg = config.modules.services.transmission;
in {
  options.modules.services.transmission = {
    enable = mkEnableOption "Transmission";
  };

  config = mkIf cfg.enable {
    services.transmission = {
      enable = true;
      # home = "${config.user.home}/torrents";
      openFirewall = true;
      settings = {
        incomplete-dir-enabled = true;
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-host-whitelist = "*";
        rpc-host-whitelist-enabled = true;
      };
    };

    user.extraGroups = [ "transmission" ];
  };
}
