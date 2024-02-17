{ config, lib, ... }:
with lib;
let cfg = config.modules.services.transmission;
in {
  options.modules.services.transmission = {
    enable = mkEnableOption "Transmission";
    folder = my.mkOpt types.path "${config.user.home}/torrents";
  };

  config = mkIf cfg.enable {
    services.transmission = {
      enable = true;
      home = cfg.folder;
      openFirewall = true;
      downloadDirPermissions = "770";
      settings = {
        incomplete-dir-enabled = true;
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-host-whitelist = "*";
        rpc-host-whitelist-enabled = true;
        umask = 0;
      };
    };

    user.extraGroups = [ "transmission" ];
  };
}
