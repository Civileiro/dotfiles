{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.editors.nvim;
  devCfg = config.modules.dev;
  shellCfg = config.modules.shell;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.nvim = {
    enable = mkEnableOption "Neovim";
  };

  config = mkIf cfg.enable {
    hmModules = [{
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        plugins = with pkgs.vimPlugins; flatten [
          catppuccin-nvim # theme
          telescope-nvim # fuzzy finder
          nvim-treesitter.withAllGrammars # syntax tree builder & highlighter
          harpoon # quick select menu
          undotree # access nvim's undo tree
          vim-fugitive gitsigns-nvim # git integration
          nvim-lspconfig # configuring LSP's
          nvim-cmp # auto completion engine
          cmp-buffer cmp-path cmp-cmdline cmp-git # completions sources
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
          (optional shellCfg.tmux.enable vim-tmux-navigator) # tmux integration 
        ];
      };
    }];
    user.packages = with pkgs; [
      lua-language-server
    ];
    modules.dev.lsp.enable = true;
    home.config.file = {
      "nvim" = { source = "${configDir}/nvim"; recursive = true; };
    };
  };
}
