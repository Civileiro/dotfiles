{ config, lib, ... }:

with lib;
let cfg = config.modules.dev;
in {
  options.modules.dev = {
    lsp.enable = mkEnableOption "LSP";
    xdg.enable = mkEnableOption "XDG";
  };

  config = {
    # TODO
  };
}
