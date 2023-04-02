{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.desktop.apps.vscode;
in {
  options.modules.desktop.apps.vscode = {
    enable = mkEnableOption "VSCode";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      vscode
    ];
  };
}