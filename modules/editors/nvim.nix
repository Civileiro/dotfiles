{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.editors.nvim;
  devCfg = config.modules.dev;
  shellCfg = config.modules.shell;
  terminalCfg = config.modules.desktop.terminal;
in {
  options.modules.editors.nvim = with types; {
    enable = mkEnableOption "Neovim";
    settings = mkOption {
      type = attrsOf (nullOr (oneOf [ bool int float str ]));
      default = { };
      description = "Global variables to set for the Neovim config";
    };
    extraPlugins = mkOption {
      type = listOf attrs;
      default = [ ];
      description = "Extra plugins to add to neovim";
    };
    finalPackage = mkOption {
      type = package;
      readOnly = true;
      description = "Resulting customized neovim package";
    };
  };

  config = let
    plugins = with pkgs.vimPlugins;
      cfg.extraPlugins ++ lib.flatten [
        telescope-nvim # fuzzy finder
        nvim-treesitter.withAllGrammars # syntax tree builder & highlighter
        playground # show syntax tree
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
        conform-nvim # integrate formatters
        nvim-ufo # modern folds
        actions-preview-nvim # preview code actions
        aerial-nvim # code outline window
        (optional devCfg.haskell.enable haskell-tools-nvim)
        (optional devCfg.rust.enable rustaceanvim)
        (optional shellCfg.tmux.enable vim-tmux-navigator) # tmux integration
        # (optional terminalCfg.kitty.enable vim-kitty-navigator) # handled in kitty config
      ];

    # extend plugin list with dependencies
    allPlugins = let
      pluginWithDeps = plugin:
        [ plugin ]
        ++ builtins.concatMap pluginWithDeps plugin.dependencies or [ ];
    in lib.unique (builtins.concatMap pluginWithDeps plugins);

    # remove help tags
    removeTags = map (plugin:
      plugin.overrideAttrs (prev: {
        nativeBuildInputs =
          lib.remove pkgs.vimUtils.vimGenDocHook prev.nativeBuildInputs or [ ];
        configurePhase = concatStringsSep "\n" (builtins.filter (s: s != ":") [
          prev.configurePhase or ":"
          "rm -f doc/tags"
        ]);
      }));

    # Merge all plugins to one pack
    mergedPlugins = pkgs.vimUtils.toVimPlugin (pkgs.buildEnv {
      name = "plugin-pack";
      paths = removeTags allPlugins;
      pathsToLink = [
        # :h rtp
        "/autoload"
        "/colors"
        "/compiler"
        "/doc"
        "/ftplugin"
        "/indent"
        "/keymap"
        "/lang"
        "/lsp"
        "/lua"
        "/pack"
        "/parser"
        "/plugin"
        "/queries"
        "/rplugin"
        "/spell"
        "/syntax"
        "/tutor"
        "/after"
        # ftdetect
        "/ftdetect"
        # plenary.nvim
        "/data"
        # telescope-fzf-native-nvim
        "/build"
      ];
      # Activate vimGenDocHook manually
      postBuild = ''
        find $out -type d -empty -delete
        runHook preFixup
      '';
    });

    # neovim wrapper config
    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      plugins = [ mergedPlugins ];
      viAlias = true;
      vimAlias = true;
      # don't need these
      withPython3 = false;
      withRuby = false;
      withNodeJs = false;
      # make nvim read from ~/.config/nvim
      wrapRc = false;
    };

    # final neovim derivation
    myNeovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped neovimConfig;

  in mkIf cfg.enable {

    modules.editors.nvim.finalPackage = myNeovim;

    user.packages = with pkgs; [ cfg.finalPackage lua-language-server ];

    # Turn on all our dev tools
    modules.dev = {
      lsp.enable = true;
      formatter.enable = true;
      linter.enable = true;
    };
    # put configuration files in .config/nvim
    home.config.file = {
      "nvim" = {
        source = "${config.dotfiles.configDir}/nvim";
        recursive = true;
      };
      "nvim/lua/settings.lua".text = concatStringsSep "\n" (mapAttrsToList
        (n: v:
          let
            type = builtins.typeOf v;
            value =
              if type == "string" then ''"${v}"'' else builtins.toString v;
          in ''vim.g["${n}"] = ${value}'') cfg.settings);
    };

    system.userActivationScripts.cleanupNvimCache = ''
      rm -rf ${config.home.cache.path}/nvim/luac
    '';

  };
}
