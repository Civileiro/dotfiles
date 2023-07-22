{ config, lib, ... }:
with lib;
let 
  cfg = config.modules.desktop.terminal;
in {
  options.modules.desktop.terminal = {
    default = my.mkOpt types.str "xterm";
  };

  config = {
    services.xserver.desktopManager.xterm.enable = mkDefault (cfg.default == "xterm");

    env.TERMINAL = cfg.default;
  };
}
