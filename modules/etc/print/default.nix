# https://nixos.wiki/wiki/Printing
{ pkgs, ... }:
{
  services.printing.enable = true;
  services.avahi.enable = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;
  # for an USB printer
  services.ipp-usb.enable = true;

  services.printing.drivers = [ 
    pkgs.gutenprint
    pkgs.hplip
  ];
}