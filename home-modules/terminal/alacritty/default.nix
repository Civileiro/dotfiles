{ font-size, ... }:
{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.9;
        font = {
          normal.family = "FiraCode Nerd Font";
          size = font-size;
        };
      };
    };
  };
}