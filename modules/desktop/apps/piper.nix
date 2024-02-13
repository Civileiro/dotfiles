{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.apps.piper;
in {
  options.modules.desktop.apps.piper = { enable = mkEnableOption "Piper"; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ piper ];
    services.ratbagd.enable = true;
  };
}
