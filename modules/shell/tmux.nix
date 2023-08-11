{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.shell.tmux;
  configDir = config.dotfiles.configDir;
  configFiles = my.readDirNames "${configDir}/tmux";
in {
  options.modules.shell.tmux = with types; {
    enable = mkEnableOption "tmux";
    extraPlugins = my.mkListOf anything;
    extraPluginsAfter = my.mkListOf anything;
  };

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
          plugins = let
            basePlugins = with pkgs.tmuxPlugins; [
              vim-tmux-navigator # vim integration
              { # save tmux session through restarts
                plugin = resurrect;
                extraConfig = ''
                  set -g @resurrect-dir "~/.local/share/tmux/resurrect"
                '';
              }
              { # tmux always on and saving
                plugin = continuum;
                extraConfig = ''
                  set -g @continuum-boot "on"
                  set -g @continuum-restore "on"
                '';
              }
            ];
          in cfg.extraPlugins ++ basePlugins ++ cfg.extraPluginsAfter;
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
