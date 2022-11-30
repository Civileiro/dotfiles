{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli
    kubectl
    dbeaver
    lens
    google-chrome
  ];
}