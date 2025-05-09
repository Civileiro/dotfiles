# modules/desktop/apps/default.nix

# All simple single package apps here

{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.apps;
in {
  options.modules.desktop.apps = {
    vscode.enable = mkEnableOption "VSCode";
    discord.enable = mkEnableOption "Discord";
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.vscode.enable vscode)
      (mkIf cfg.discord.enable vesktop)
    ];
  };
}
