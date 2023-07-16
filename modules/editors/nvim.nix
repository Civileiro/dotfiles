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
          nvim-treesitter # syntax tree builder & highlighter
          harpoon # quick select menu
          undotree # access nvim's undo tree
          vim-fugitive # git integration
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
          (optional shellCfg.tmux.enable vim-tmux-navigator) # tmux integration
        ] ++ (with nvim-treesitter-parsers; flatten [
          nix lua bash # we always have these
          toml json yaml markdown html # these are everywhere
          (optional devCfg.cc.enable [c cpp make])
          (optional devCfg.rust.enable rust)
          (optional devCfg.python.enable python)
          haskell
          go
          elixir
          javascript
          typescript
          zig
        ]);
      };
    }];
    user.packages = with pkgs; [
      lua-language-server
    ];
    modules.dev.rust.lsp.enable = true;
    home.config.file = {
      "nvim" = { source = "${configDir}/nvim"; recursive = true; };
    };
  };
}
