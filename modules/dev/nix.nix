# modules/dev/nix.nix

{ config, lib, pkgs, ... }:
with lib;
let
  devCfg = config.modules.dev;
  cfg = devCfg.nix;
in {
  options.modules.dev.nix = {
    enable = mkEnableOption "Nix Dev";
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
    formatter.enable = my.mkBoolOpt devCfg.formatter.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nix-output-monitor
      nvd
      (mkIf cfg.formatter.enable nixfmt-classic)
      (mkIf cfg.lsp.enable nil)
    ];
  };
}
