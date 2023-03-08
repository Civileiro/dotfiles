{ pkgs, ... }:
{
  home.packages = with pkgs; [
    chromium
    wireshark
  ];
}
