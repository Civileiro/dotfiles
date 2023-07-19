# modules/dev/nix.nix

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.nix;
in {
  options.modules.dev.nix = {
    enable = mkEnableOption "Nix Dev";
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.lsp.enable nil)
    ];
  };
}
