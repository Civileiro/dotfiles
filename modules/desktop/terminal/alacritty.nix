{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.desktop.terminal.alacritty;
in {
  options.modules.desktop.terminal.alacritty = {
    enable = mkEnableOption "Alacritty";
    fontsize = my.mkOpt types.int 16;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      alacritty
    ];

    home.configFile = {
      "alacritty/alacritty.yml".text = builtins.toJSON {
        font = {
          normal = {
            family = "FiraCode Nerd Font";
          };
          size = cfg.fontsize;
        };
        window = {
          opacity = 0.9;
          dynamic_padding = true;
        };
      };
    };
    
  };
}