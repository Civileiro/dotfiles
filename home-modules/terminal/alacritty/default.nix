{ font-size, ... }:
{ pkgs, ... }:
{
  programs = {
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