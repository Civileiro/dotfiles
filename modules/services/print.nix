
{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.services.print;
in {
  options.modules.services.print = {
    enable = mkEnableOption "Printer Drivers";
  };
  
  config = mkIf cfg.enable {
    
    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.avahi.enable = true;
    # for a WiFi printer
    services.avahi.openFirewall = true;
    # for an USB printer
    services.ipp-usb.enable = true;

    services.printing.drivers = [ pkgs.gutenprint pkgs.hplip ];
  };
}
