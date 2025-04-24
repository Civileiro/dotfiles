{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.terminal.kitty;
in {
  options.modules.desktop.terminal.kitty = {
    enable = mkEnableOption "Kitty";
    fontsize = my.mkOpt types.int 16;
    configImports = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "kitty configs to import";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [ kitty ];

      home.config.file = {
        "kitty/kitty.conf".text = let
          defaultConfig = pkgs.writeText "default.conf" ''
            font_family FiraCode Nerd Font
            disable_ligatures cursor
            font_size ${builtins.toString cfg.fontsize}
            background_opacity 0.85
            confirm_os_window_close -10

            map ctrl+left neighboring_window left
            map ctrl+down neighboring_window down
            map ctrl+right neighboring_window right
            map ctrl+up neighboring_window up

            map ctrl+alt+left move_window left
            map ctrl+alt+down move_window down
            map ctrl+alt+right move_window right
            map ctrl+alt+up move_window up

            enabled_layouts tall,fat,stack
            map ctrl+alt+\ toggle_layout tall
            map ctrl+alt+minus toggle_layout fat
            map ctrl+alt+z toggle_layout stack

            map ctrl+alt+1 goto_tab 1
            map ctrl+alt+2 goto_tab 2
            map ctrl+alt+3 goto_tab 3
            map ctrl+alt+4 goto_tab 4
            map ctrl+alt+5 goto_tab 5
            map ctrl+alt+6 goto_tab 6
            map ctrl+alt+7 goto_tab 7
            map ctrl+alt+8 goto_tab 8
            map ctrl+alt+9 goto_tab 9

            map kitty_mod+enter launch --cwd=current
          '';
          modules = unique ([ defaultConfig ] ++ cfg.configImports);
          include = str: "include ${str}";
          includes = map include modules;
        in strings.concatLines includes;
      };

    }
    (let nav = pkgs.vimPlugins.vim-kitty-navigator;
    in mkIf config.modules.editors.nvim.enable {
      modules.editors.nvim.extraPlugins = [ nav ];
      home.config.file = {
        "kitty/pass_keys.py".source = "${nav}/pass_keys.py";
        "kitty/get_layout.py".source = "${nav}/get_layout.py";
      };
      modules.desktop.terminal.kitty.configImports = [
        (pkgs.writeText "nav-mappings.conf" ''
          allow_remote_control yes
          listen_on unix:@mykitty


          map ctrl+down  kitten pass_keys.py bottom ctrl+down
          map ctrl+up    kitten pass_keys.py top    ctrl+up
          map ctrl+left  kitten pass_keys.py left   ctrl+left
          map ctrl+right kitten pass_keys.py right  ctrl+right
        '').outPath
      ];
    })
  ]);
}
