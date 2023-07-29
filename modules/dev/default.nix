{ lib, ... }:

with lib; {
  options.modules.dev = {
    lsp.enable = mkEnableOption "LSP";
    formatter.enable = mkEnableOption "Formatters";
    linter.enable = mkEnableOption "Linters";
    xdg.enable = mkEnableOption "XDG";
  };
}
