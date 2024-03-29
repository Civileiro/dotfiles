{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.editors.nvim;
  devCfg = config.modules.dev;
  shellCfg = config.modules.shell;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.nvim = with types; {
    enable = mkEnableOption "Neovim";
    settings = mkOption {
      type = attrsOf (nullOr (oneOf [ bool int float str ]));
      default = { };
      description = ''
        Global variables to set for the Neovim config
      '';
    };
  };

  config = mkIf cfg.enable {
    hmModules = [{
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        plugins = with pkgs.vimPlugins;
          flatten [
            telescope-nvim # fuzzy finder
            nvim-treesitter.withAllGrammars # syntax tree builder & highlighter
            playground # show syntax tree
            harpoon # quick select menu
            undotree # access nvim's undo tree
            vim-fugitive
            gitsigns-nvim # git integration
            nvim-lspconfig # configuring LSP's
            nvim-cmp # auto completion engine
            cmp-buffer
            cmp-path
            cmp-cmdline
            cmp-git # completions sources
            cmp-nvim-lua # nvim lua config completions
            cmp-nvim-lsp-signature-help # display function signatures
            cmp-nvim-lsp # config cmp nvim lsp
            luasnip # snippet engine
            cmp_luasnip # luasnip completion source
            nvim-web-devicons # pretty icons
            trouble-nvim # diagnostic pretty lister
            neo-tree-nvim # pretty file tree
            lualine-nvim # status
            lualine-lsp-progress # show lsp loading progress
            nvim-notify # fancy notifications
            guess-indent-nvim # automatic indentation detection
            nvim-autopairs # autocomplete pairs ()[]{}""
            indent-blankline-nvim # mark indentation levels
            comment-nvim # autocomment lines/blocks
            toggleterm-nvim # terminal in nvim pog
            neoscroll-nvim # smooth scrolling
            nvim-scrollbar # fancy scrollbar
            nvim-lint # support non-lsp diagnostics
            formatter-nvim # integrate formatters
            (optional devCfg.haskell.enable haskell-tools-nvim)
            (optional devCfg.rust.enable rust-tools-nvim)
            (optional shellCfg.tmux.enable
              vim-tmux-navigator) # tmux integration
          ];
      };
    }];
    user.packages = with pkgs; [ lua-language-server ];
    # Turn on all our dev tools
    modules.dev = {
      lsp.enable = true;
      formatter.enable = true;
      linter.enable = true;
    };
    home.config.file = {
      "nvim/init.lua".source = "${configDir}/nvim/init.lua";
      "nvim/lua/self" = {
        source = "${configDir}/nvim/lua/self";
        recursive = true;
      };
      "nvim/lua/settings.lua".text = concatStringsSep "\n" (mapAttrsToList (n: v:
        let
          type = builtins.typeOf v;
          value = if type == "string" then ''"${v}"'' else builtins.toString v;
        in ''vim.g["${n}"] = ${value}'') cfg.settings);
    };
  };
}
