# modules/dev/js.nix

{ config, lib, pkgs, ... }:
with lib;
let
  devCfg = config.modules.dev;
  cfg = devCfg.js;
in {
  options.modules.dev.js = {
    enable = mkEnableOption "JavaScript";
    install = my.mkBoolOpt false;
    lsp.enable = my.mkBoolOpt devCfg.lsp.enable;
    formatter.enable = my.mkBoolOpt devCfg.formatter.enable;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.install nodejs)
      (mkIf cfg.install typescript)
      (mkIf cfg.install nodePackages.npm)
      (mkIf cfg.lsp.enable nodePackages.vscode-json-languageserver)
      (mkIf cfg.lsp.enable nodePackages.typescript-language-server)
      (mkIf cfg.formatter.enable jq)
    ];
  };
}
