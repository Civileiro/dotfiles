# modules/dev/wgsl.nix

{ config, lib, pkgs, ... }:
with lib;
let
  devCfg = config.modules.dev;
  cfg = devCfg.wgsl;
in {
  options.modules.dev.wgsl = {
    enable = mkEnableOption "WGSL";
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ (mkIf cfg.lsp.enable wgsl-analyzer) ];
  };
}
