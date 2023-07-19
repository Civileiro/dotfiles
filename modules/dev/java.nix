# modules/dev/haskell.nix

{ config, lib, pkgs, ... }:
with lib;
let devCfg = config.modules.dev;
    cfg = devCfg.java;
in {
  options.modules.dev.java = {
    enable = mkEnableOption "Java";
    install = my.mkBoolOpt false;
    package = mkOption {
      default = pkgs.jdk;
      type = types.package;
    };
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
  };

  config = mkIf cfg.enable {
    programs.java = {
      enable = cfg.install;
      package = cfg.package;
    };
    user.packages = with pkgs; [
      (mkIf cfg.lsp.enable jdt-language-server)
    ];
  };
}
