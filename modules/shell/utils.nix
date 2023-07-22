{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.shell.utils;
in {
  options.modules.shell.utils = {
    btop.enable = mkEnableOption "btop";
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.btop.enable btop)
    ];
  };
}
