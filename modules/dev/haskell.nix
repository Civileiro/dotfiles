# modules/dev/haskell.nix

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.haskell;
in {
  options.modules.dev.haskell = {
    enable = mkEnableOption "Haskell";
    install = my.mkBoolOpt false;
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.install ghc)
      (mkIf cfg.lsp.enable haskell-language-server)
    ];
  };
}
