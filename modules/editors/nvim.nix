{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.editors.nvim;
in {
  options.modules.editors.nvim = {
    enable = mkEnableOption "Neovim";
  };

  config = mkIf cfg.enable {
    
    user.packages = with pkgs; [
      neovim
    ];

    environment.shellAliases = {
      vim = "nvim";
      v   = "nvim";
    };
    programs.neovim = {
      enable = true;
      configure = {
        customRC = ''
          " here your custom configuration goes!
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          # loaded on launch
          start = [ vim-nix ];
          # manually loadable by calling `:packadd $plugin-name`
          opt = [ ];
        };
      };
    };
  };
}