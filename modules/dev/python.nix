# modules/dev/python.nix

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.python;
in {
  options.modules.dev.python = {
    enable = mkEnableOption "Python";
    install = my.mkBoolOpt true;
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.install python3)
      (mkIf cfg.lsp.enable nodePackages.pyright)
    ];
  };
}
