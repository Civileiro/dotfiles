{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.terminal.alacritty;
in {
  options.modules.desktop.terminal.alacritty = {
    enable = mkEnableOption "Alacritty";
    fontsize = my.mkOpt types.int 16;
    configImports = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "alacritty configs to import";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ alacritty ];

    home.config.file = {
      "alacritty/alacritty.toml".text = let
        toml = pkgs.formats.toml { };
        defaultConfig = toml.generate "alacritty.toml" {
          env.TERM = "xterm-256color";
          font = {
            normal = { family = "FiraCode Nerd Font"; };
            size = cfg.fontsize;
          };
          window = {
            dynamic_padding = true;
            opacity = 0.85;
          };
        };
        alacrittyModules = unique ([ defaultConfig ] ++ cfg.configImports);
        quote = str: ''"${str}"'';
        modulePaths = concatMapStringsSep ", " quote alacrittyModules;
      in "general.import = [ ${modulePaths} ]";
    };

  };
}
