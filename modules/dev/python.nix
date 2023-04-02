# modules/dev/python.nix

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.python;
in {
  options.modules.dev.python = {
    enable = mkEnableOption "Python";
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        python3
      ];
    })
  ];
}