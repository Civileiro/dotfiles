{ pkgs, ...}:
{
  imports = [
    (import ../../home-modules/terminal/alacritty { font-size = 16; })
    # (import ../work/home.nix)
    (import ../college/home.nix)
  ];
}