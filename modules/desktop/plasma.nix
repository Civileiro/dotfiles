{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.plasma;
in {

  options.modules.desktop.plasma = {
    enable = mkEnableOption "KDE Plasma";
    wayland.enable = mkEnableOption "KWayland";
  };

  config = mkIf cfg.enable {

    modules.desktop = {
      x.enable = true;
      wayland.enable = true;
      de = [ "plasma" ];
    };

    services.xserver = {
      enable = true;
      displayManager = {
        # wayland default
        defaultSession = "plasma";
        sddm = {
          enable = true;
          autoNumlock = true;
        };
      };
      desktopManager.plasma6.enable = true;

    };

    environment = {
      systemPackages = with pkgs; [
        libsForQt5.ark
        libsForQt5.filelight
        libsForQt5.ffmpegthumbs
        wineWowPackages.stable
        wl-clipboard
      ];
      plasma6 = {
        excludePackages = with pkgs.libsForQt5; [
          elisa
          gwenview
          okular
          # oxygen
          khelpcenter
          konsole
          # plasma-browser-integration
          # print-manager
        ];
      };
    };
  };
}
