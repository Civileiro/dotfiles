{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = mkEnableOption "ZSH";
    pluginInit = my.mkOpt types.lines "";
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      # I init completion myself, because enableGlobalCompInit initializes it
      # too soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableGlobalCompInit = false;

      # ohMyZsh = {
      #   enable = true;
      #
      # };
    };

    user = {
      shell = pkgs.zsh;
      packages = with pkgs;
        [
          # completions for some random commands
          zsh-completions
          # most other plugins dont need to be here
          # they just need to be sourced in rc
        ];
    };

    modules.shell = {
      utils.enable = true;
      # who needs a plugin manager anyway
      zsh.pluginInit = with pkgs; ''
        source "$(fzf-share)/key-bindings.zsh"

        source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

        source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

        source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30

        source ${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

        source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        source ${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
        autopair-init
      '';
    };

    home.config.file = {
      "zsh" = {
        source = "${config.dotfiles.configDir}/zsh";
        recursive = true;
      };
      "zsh/plugins.zsh".text = cfg.pluginInit;
    };

    env = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
    };

    system.userActivationScripts.cleanupZgen = ''
      rm -rf $ZSH_CACHE
    '';
  };
}
