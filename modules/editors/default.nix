{ config, lib, ... }:
with lib;
let cfg = config.modules.editors;
in {
  options.modules.editors = { default = my.mkOpt types.str "nvim"; };

  config = mkIf (cfg.default != null) { env.EDITOR = cfg.default; };
}
