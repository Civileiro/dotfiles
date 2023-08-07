{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.shell.tmux;
  configDir = config.dotfiles.configDir;
  configFiles = my.readDirNames "${configDir}/tmux";
in {
  options.modules.shell.tmux = { enable = mkEnableOption "tmux"; };

  config = mkIf cfg.enable {
    hmModules = [
      ({ config, ... }: {
        programs.tmux = {
          enable = true;
          sensibleOnTop = false;
          # source all our tmux config files
          extraConfig = concatMapStrings (file: ''
            source ${config.xdg.configHome}/tmux/${file}
          '') configFiles;
          plugins = with pkgs.tmuxPlugins; [
            catppuccin # theme
            vim-tmux-navigator # vim integration
            resurrect # save tmux session through restarts
            continuum # tmux always on and saving
          ];
        };
      })
    ];
    home.config.file = {
      "tmux" = {
        source = "${configDir}/tmux";
        recursive = true;
      };
    };
  };
}
