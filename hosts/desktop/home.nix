{ pkgs, ...}:
{
  imports = [
    ((import ../../modules/terminal/alacritty) { font-size = 20; })
  ];
}