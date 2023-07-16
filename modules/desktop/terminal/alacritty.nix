{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.desktop.terminal.alacritty;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.terminal.alacritty = {
    enable = mkEnableOption "Alacritty";
    fontsize = my.mkOpt types.int 16;
    configImports = mkOption {
      type = with types; listOf str;
      default = [];
      description = "alacritty to import";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      alacritty
    ];

    home.config.file = {
      "alacritty/alacritty.yml".text = let
        toImportItem = (module: "  - ${config.home.config.path}/alacritty/${module}.yml\n");
        base = [ "gen" "default" ];
        alacrittyModules = unique (base ++ cfg.configImports);
        in "import:\n" + concatMapStrings toImportItem alacrittyModules;
      "alacritty/default.yml".source ="${configDir}/alacritty/default.yml";
      "alacritty/gen.yml".text = builtins.toJSON {
        font = {
          normal = {
            family = "FiraCode Nerd Font";
          };
          size = cfg.fontsize;
        };
        window = {
          # opacity = 0.9;
        };
      };
    };
    
  };
}
