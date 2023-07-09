# modules/dev/nix.nix

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.nix;
in {
  options.modules.dev.nix = {
    enable = mkEnableOption "Nix Dev";
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nil # Nix LSP
    ];
  };
}