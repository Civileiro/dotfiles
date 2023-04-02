{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.shell.utils;
in {
  options.modules.shell.utils = {
    btop.enable = mkEnableOption "btop";
    file.enable = mkEnableOption "file";
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.btop.enable btop)
      (mkIf cfg.btop.enable file)
    ];
  };
}