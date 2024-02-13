# modules/desktop/apps/default.nix

# All simple single package apps here

{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.apps;
in {
  options.modules.desktop.apps = {
    vscode.enable = mkEnableOption "VSCode";
    discord.enable = mkEnableOption "Discord";
    obs.enable = mkEnableOption "OBS Studio";
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.vscode.enable vscode)
      (mkIf cfg.discord.enable discord)
      (mkIf cfg.obs.enable obs-studio)
    ];
  };
}
