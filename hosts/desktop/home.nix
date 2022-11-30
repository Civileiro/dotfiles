{ pkgs, ...}:
{
  imports = [
    (import ../../home-modules/terminal/alacritty { font-size = 20; })
    (import ../work/home.nix)
  ];
}