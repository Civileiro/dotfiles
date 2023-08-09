{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = enum [ null "catppuccin" ];
      default = null;
      description = ''
        Name of the theme to enable
      '';
    };

    wallpaper = my.mkOpt (nullOr path) null;
  };
}
