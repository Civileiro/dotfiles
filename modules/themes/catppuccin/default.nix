{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.theme.catppuccin;
  tCfg = config.modules.theme;
in {
  options.modules.theme.catppuccin = with types; {
    flavour = mkOption {
      type = enum [ "mocha" "frappe" "macchiato" "latte" ];
      default = "mocha";
    };
  };

  config = mkIf (tCfg.active == "catppuccin") (mkMerge [
    (mkIf config.modules.desktop.enable {
      environment.systemPackages = with pkgs;
        [
          (catppuccin-gtk.override {
            variant = cfg.flavour;
            accents = [ "teal" ];
          })
        ];
    })
    (mkIf config.modules.desktop.plasma.enable {
      environment.systemPackages = with pkgs;
        [
          (catppuccin-kde.override {
            flavour = [ cfg.flavour ];
            accents = [ "teal" ];
            winDecStyles = [ "modern" ];
          })
        ];
    })
    (mkIf config.services.displayManager.sddm.enable {
      services.displayManager.sddm.settings = {
        General = { InputMethod = ""; };
      };
      services.displayManager.sddm.theme = "catppuccin-${cfg.flavour}";
      environment.systemPackages = with pkgs;
        [ (catppuccin-sddm.override { flavor = cfg.flavour; }) ];
    })
    (mkIf config.modules.editors.nvim.enable {
      modules.editors.nvim = {
        extraPlugins = [ pkgs.vimPlugins.catppuccin-nvim ];
        settings = {
          theme = "catppuccin";
          catppuccin_flavour = cfg.flavour;
          lualine_theme = "catppuccin";
        };
      };
    })
    (mkIf config.modules.shell.tmux.enable {
      modules.shell.tmux.extraPlugins = [{
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour "${cfg.flavour}"
        '';
      }];
    })
    (mkIf config.modules.desktop.terminal.alacritty.enable {
      modules.desktop.terminal.alacritty.configImports = let
        catppuccin-alacritty = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "alacritty";
          rev = "f2da554ee63690712274971dd9ce0217895f5ee0";
          hash = "sha256-ypYaxlsDjI++6YNcE+TxBSnlUXKKuAMmLQ4H74T/eLw=";
        };
      in [ (catppuccin-alacritty + "/catppuccin-${cfg.flavour}.toml") ];
    })
    (mkIf config.modules.desktop.terminal.kitty.enable {
      modules.desktop.terminal.kitty.configImports = let
        catppuccin-kitty = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "kitty";
          rev = "b14e8385c827f2d41660b71c7fec1e92bdcf2676";
          hash = "sha256-59ON7CzVgfZUo7F81qQZQ1r6kpcjR3OPvTl99gzDP8E=";
        };
      in [ (catppuccin-kitty + "/themes/${cfg.flavour}.conf") ];
    })
  ]);
}
