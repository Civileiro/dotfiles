{ config, lib, ... }:

with lib;
let cfg = config.modules.desktop.browsers;
in {
  options.modules.desktop.browsers = {
    default = my.mkOpt (with types; nullOr str) null;
  };

  config = mkIf (cfg.default != null) {
    env.BROWSER = cfg.default;
  };
}