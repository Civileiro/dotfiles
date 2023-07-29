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
    formatter.enable = my.mkBoolOpt devCfg.formatter.enable;
    linter.enable = my.mkBoolOpt devCfg.linter.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.install (python3.withPackages (ps: with ps; flatten [
        virtualenv
        (optional cfg.linter.enable mypy)
        (optional cfg.linter.enable ruff)
        (optional cfg.formatter.enable black)
        (optional cfg.lsp.enable ruff-lsp)
      ])))
      (mkIf cfg.lsp.enable nodePackages.pyright)
    ];
  };
}
